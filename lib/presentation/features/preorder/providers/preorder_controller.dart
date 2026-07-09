// Removed unused imports
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
import 'package:harvest_app/domain/usecases/preorder/get_preorder_data_usecase.dart';
import 'package:harvest_app/domain/usecases/preorder/reserve_preorder_usecase.dart';
import 'package:harvest_app/domain/usecases/preorder/get_active_campaigns_usecase.dart';
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

final getPreOrderDataUseCaseProvider = Provider<GetPreOrderDataUseCase>((ref) {
  return GetPreOrderDataUseCase(ref.watch(preOrderRepositoryProvider));
});

final reservePreOrderUseCaseProvider = Provider<ReservePreOrderUseCase>((ref) {
  return ReservePreOrderUseCase(ref.watch(preOrderRepositoryProvider));
});

final getActiveCampaignsUseCaseProvider =
    Provider<GetActiveCampaignsUseCase>((ref) {
  return GetActiveCampaignsUseCase(ref.watch(preOrderRepositoryProvider));
});

@riverpod
class PreOrderController extends _$PreOrderController {
  @override
  PreOrderState build() {
    _fetchData();
    return const PreOrderState.loading();
  }

  Future<void> _fetchData() async {
    state = const PreOrderState.loading();

    try {
      final usecase = ref.read(getPreOrderDataUseCaseProvider);
      final campaignUsecase = ref.read(getActiveCampaignsUseCaseProvider);

      final result = await usecase.call();
      final campaignResult = await campaignUsecase.call();

      result.fold(
        (failure) {
          state = PreOrderState.error(failure.message);
        },
        (entity) {
          campaignResult.fold(
            (fail) {
              state = PreOrderState.data(PreOrderData.fromResponseEntity(
                entity,
                selectedTabIndex: 0,
              ));
            },
            (campaigns) {
              // Map campaigns to PreOrderHarvest
              final mappedCampaigns = campaigns.map((c) {
                final daysLeft = c.deadline.difference(DateTime.now()).inDays;
                return PreOrderHarvest(
                  id: c.id,
                  title: 'Campaign Product ${c.productId}',
                  farmerName: 'Local Farmer',
                  distance: '2.5 km',
                  imageUrl: '📦',
                  price: c.depositAmount > 0 ? c.depositAmount * 5 : 50000,
                  unit: 'kg',
                  bookedQuantity: c.currentReservations.toDouble(),
                  totalQuantity: c.targetQuantity.toDouble(),
                  daysLeft: daysLeft > 0 ? daysLeft : 0,
                  status: c.status ?? 'Active',
                );
              }).toList();

              // Merge them or replace
              final updatedEntity = PreOrderResponseEntity(
                activeHarvests: entity.activeHarvests + campaigns.length,
                yourReservations: entity.yourReservations,
                avgSavings: entity.avgSavings,
                availableHarvests: [
                  ...mappedCampaigns,
                  ...entity.availableHarvests
                ],
                activeReservations: entity.activeReservations,
              );

              state = PreOrderState.data(PreOrderData.fromResponseEntity(
                updatedEntity,
                selectedTabIndex: 0,
              ));
            },
          );
        },
      );
    } catch (e) {
      state = PreOrderState.error(e.toString());
    }
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
