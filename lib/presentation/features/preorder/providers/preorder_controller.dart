// Removed unused imports
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';
import 'package:harvest_app/features/preorders/data/datasources/remote/preorder_remote_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/preorders/data/datasources/local/preorder_local_datasource.dart';
import 'package:harvest_app/features/preorders/data/repositories/preorder_repository_impl.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';
import 'package:harvest_app/domain/usecases/preorder/reserve_preorder_usecase.dart';
import 'package:harvest_app/domain/usecases/preorder/get_active_campaigns_usecase.dart';
import 'package:harvest_app/domain/usecases/preorder/get_preorder_campaign_detail_usecase.dart';
import 'package:harvest_app/domain/usecases/preorder/get_my_reservations_usecase.dart';
import 'preorder_state.dart';

part 'preorder_controller.g.dart';

// Dependency Injection Providers
final preOrderRemoteDataSourceProvider =
    Provider<PreOrderRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PreOrderRemoteDataSourceImpl(dio);
});

final preorderLocalDataSourceProvider =
    Provider<PreorderLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));
  return PreorderLocalDataSourceImpl(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
});

final preOrderRepositoryProvider = Provider<PreorderRepository>((ref) {
  return PreorderRepositoryImpl(
    remoteDataSource: ref.watch(preOrderRemoteDataSourceProvider),
    localDataSource: ref.watch(preorderLocalDataSourceProvider),
  );
});

// Removed getPreOrderDataUseCaseProvider

final reservePreOrderUseCaseProvider = Provider<ReservePreOrderUseCase>((ref) {
  return ReservePreOrderUseCase(ref.watch(preOrderRepositoryProvider));
});

final getActiveCampaignsUseCaseProvider =
    Provider<GetActiveCampaignsUseCase>((ref) {
  return GetActiveCampaignsUseCase(ref.watch(preOrderRepositoryProvider));
});

final getPreorderCampaignDetailUseCaseProvider =
    Provider<GetPreorderCampaignDetailUseCase>((ref) {
  return GetPreorderCampaignDetailUseCase(ref.watch(preOrderRepositoryProvider));
});

final preorderDetailProvider = FutureProvider.family<PreorderCampaign, String>((ref, id) async {
  final usecase = ref.watch(getPreorderCampaignDetailUseCaseProvider);
  final result = await usecase.call(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (campaign) => campaign,
  );
});

final getMyReservationsUseCaseProvider = Provider<GetMyReservationsUseCase>((ref) {
  return GetMyReservationsUseCase(ref.watch(preOrderRepositoryProvider));
});

final myReservationsProvider = FutureProvider.autoDispose<List<PreOrderReservation>>((ref) async {
  final usecase = ref.watch(getMyReservationsUseCaseProvider);
  final result = await usecase.call();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (reservations) => reservations,
  );
});

@riverpod
class PreOrderController extends _$PreOrderController {
  @override
  PreOrderState build() {
    Future.microtask(() => _fetchData());
    return const PreOrderState.loading();
  }

  Future<void> _fetchData({bool showLoading = true}) async {
    int currentTabIndex = 0;
    state.maybeWhen(
      data: (data) => currentTabIndex = data.selectedTabIndex,
      orElse: () {},
    );

    if (showLoading) {
      state = const PreOrderState.loading();
    }

    try {
      final campaignUsecase = ref.read(getActiveCampaignsUseCaseProvider);
      final campaignResult = await campaignUsecase.call();

      campaignResult.fold(
        (failure) {
          state = PreOrderState.error(failure.message);
        },
        (campaigns) {
          // Map campaigns to PreOrderHarvest
          final mappedCampaigns = campaigns.map((c) {
            final daysLeft = c.deadline.difference(DateTime.now()).inDays;
            return PreOrderHarvest(
              id: c.id,
              title: c.productName ?? 'Unknown Product',
              farmerName: c.farmerName ?? 'Local Farmer',
              distance: c.distance?.toString() ?? '2.5 km',
              imageUrl: c.productImage ?? 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&q=80',
              price: c.price ?? c.depositAmount,
              unit: c.unit ?? 'kg',
              bookedQuantity: c.currentReservations.toDouble(),
              totalQuantity: c.targetQuantity.toDouble(),
              daysLeft: daysLeft > 0 ? daysLeft : 0,
              status: c.status ?? 'Active',
            );
          }).toList();

          final entity = PreOrderResponseEntity(
            activeHarvests: campaigns.length,
            yourReservations: 0,
            avgSavings: "0%",
            availableHarvests: mappedCampaigns,
            activeReservations: const [], 
          );

          state = PreOrderState.data(PreOrderData.fromResponseEntity(
            entity,
            selectedTabIndex: currentTabIndex,
          ));
        },
      );
    } catch (e) {
      state = PreOrderState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchData(showLoading: false);
  }

  void setTabIndex(int index) {
    state.maybeWhen(
      data: (data) {
        state = PreOrderState.data(data.copyWith(selectedTabIndex: index));
      },
      orElse: () {},
    );
  }

  Future<bool> reserveHarvest(
    PreOrderHarvest harvest, {
    required int quantity,
    required String deliveryMethod,
    String? addressId,
  }) async {
    bool isSuccess = false;
    await state.maybeWhen(
      data: (data) async {
        // Optimistic UI update
        final newBookedQuantity = harvest.bookedQuantity + quantity;
        final updatedHarvests = data.availableHarvests.map((h) {
          if (h.id == harvest.id) {
            return PreOrderHarvest(
              id: h.id,
              title: h.title,
              farmerName: h.farmerName,
              distance: h.distance,
              imageUrl: h.imageUrl,
              price: h.price,
              unit: h.unit,
              bookedQuantity: newBookedQuantity,
              totalQuantity: h.totalQuantity,
              daysLeft: h.daysLeft,
              status: h.status,
            );
          }
          return h;
        }).toList();

        final updatedYourReservations = data.yourReservations + 1;

        // Optionally, add a dummy reservation to activeReservations list right away
        final newReservation = PreOrderReservation(
          id: 'r_optimistic',
          campaignId: harvest.id,
          productId: harvest.id,
          title: harvest.title,
          farmerName: harvest.farmerName,
          quantityStr: '$quantity ${harvest.unit}',
          imageUrl: harvest.imageUrl,
          status: 'Pending',
          daysToHarvest: harvest.daysLeft,
        );
        final updatedActiveReservations = [
          newReservation,
          ...data.activeReservations
        ];

        state = PreOrderState.data(data.copyWith(
          availableHarvests: updatedHarvests,
          yourReservations: updatedYourReservations,
          activeReservations: updatedActiveReservations,
        ));

        // Call backend API
        final usecase = ref.read(reservePreOrderUseCaseProvider);
        final result = await usecase.call(
          harvestId: harvest.id,
          quantity: quantity,
          deliveryMethod: deliveryMethod,
          addressId: addressId,
        );

        result.fold(
          (failure) {
            // Revert changes or show error message
            isSuccess = false;
          },
          (responseData) {
            // Success! The background API updated successfully.
            isSuccess = true;
          },
        );
      },
      orElse: () async {
        isSuccess = false;
      },
    );
    return isSuccess;
  }

  Future<bool> createCampaign(CreatePreorderCampaignParams params) async {
    final repository = ref.read(preOrderRepositoryProvider);
    final result = await repository.createCampaign(params);
    return result.fold(
      (failure) => false,
      (campaign) => true,
    );
  }
}
