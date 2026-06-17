import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';
import 'package:harvest_app/data/datasources/remote/harvest_schedule_remote_datasource.dart';
import 'package:harvest_app/data/repositories/harvest_schedule_repository_impl.dart';
import 'package:harvest_app/domain/repositories/harvest_schedule_repository.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/get_harvest_schedule_usecase.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/pay_deposit_usecase.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/arrange_pickup_usecase.dart';
import 'harvest_schedule_state.dart';

part 'harvest_schedule_controller.g.dart';

// Dependency Injection Providers
final harvestScheduleRemoteDataSourceProvider = Provider<HarvestScheduleRemoteDataSource>((ref) {
  return HarvestScheduleRemoteDataSourceImpl(Dio());
});

final harvestScheduleRepositoryProvider = Provider<HarvestScheduleRepository>((ref) {
  return HarvestScheduleRepositoryImpl(ref.watch(harvestScheduleRemoteDataSourceProvider));
});

final getHarvestScheduleUseCaseProvider = Provider<GetHarvestScheduleUseCase>((ref) {
  return GetHarvestScheduleUseCase(ref.watch(harvestScheduleRepositoryProvider));
});

final payDepositUseCaseProvider = Provider<PayDepositUseCase>((ref) {
  return PayDepositUseCase(ref.watch(harvestScheduleRepositoryProvider));
});

final arrangePickupUseCaseProvider = Provider<ArrangePickupUseCase>((ref) {
  return ArrangePickupUseCase(ref.watch(harvestScheduleRepositoryProvider));
});

@riverpod
class HarvestScheduleController extends _$HarvestScheduleController {
  @override
  HarvestScheduleState build() {
    _fetchData();
    return const HarvestScheduleState.loading();
  }

  Future<void> _fetchData() async {
    state = const HarvestScheduleState.loading();

    final usecase = ref.read(getHarvestScheduleUseCaseProvider);
    final result = await usecase.call(month: '2026-06');

    result.fold(
      (failure) {
        state = HarvestScheduleState.error(failure.message);
      },
      (entity) {
        state = HarvestScheduleState.data(HarvestScheduleData.fromEntity(entity));
      },
    );
  }

  void toggleDateFilter(String day) {
    state.maybeWhen(
      data: (data) {
        if (data.selectedDateFilter == day) {
          // Deselect
          state = HarvestScheduleState.data(data.copyWith(clearFilter: true));
        } else {
          // Select
          state = HarvestScheduleState.data(data.copyWith(selectedDateFilter: day));
        }
      },
      orElse: () {},
    );
  }

  Future<void> payDeposit(HarvestScheduleItemEntity item) async {
    state.maybeWhen(
      data: (data) async {
        // Optimistic Update
        final updatedItems = data.items.map((i) {
          if (i.id == item.id) {
            final newBadges = List<String>.from(i.badges)
              ..remove('Pending confirmation')
              ..add('Deposit Paid');
            return HarvestScheduleItemEntity(
              id: i.id,
              title: i.title,
              farmerName: i.farmerName,
              distance: i.distance,
              imageUrl: i.imageUrl,
              statusText: i.statusText,
              price: i.price,
              badges: newBadges,
              descriptionText: i.descriptionText.replaceAll('deposit pending', 'deposit paid'),
              actionButton1: 'View\\ndetails',
              actionButton2: '',
              dateGroup: i.dateGroup,
              isToday: i.isToday,
              dateDayFilter: i.dateDayFilter,
            );
          }
          return i;
        }).toList();

        state = HarvestScheduleState.data(data.copyWith(items: updatedItems));

        final usecase = ref.read(payDepositUseCaseProvider);
        final result = await usecase.call(harvestId: item.id);

        result.fold(
          (failure) {
            // Revert on failure
          },
          (success) {
            // Confirm success if needed
          },
        );
      },
      orElse: () {},
    );
  }

  Future<void> arrangePickup(HarvestScheduleItemEntity item) async {
    state.maybeWhen(
      data: (data) async {
        // Optimistic Update
        final updatedItems = data.items.map((i) {
          if (i.id == item.id) {
            final newBadges = List<String>.from(i.badges)..add('Pickup Arranged');
            return HarvestScheduleItemEntity(
              id: i.id,
              title: i.title,
              farmerName: i.farmerName,
              distance: i.distance,
              imageUrl: i.imageUrl,
              statusText: i.statusText,
              price: i.price,
              badges: newBadges,
              descriptionText: i.descriptionText,
              actionButton1: 'Chat\\nfarmer',
              actionButton2: '',
              dateGroup: i.dateGroup,
              isToday: i.isToday,
              dateDayFilter: i.dateDayFilter,
            );
          }
          return i;
        }).toList();

        state = HarvestScheduleState.data(data.copyWith(items: updatedItems));

        final usecase = ref.read(arrangePickupUseCaseProvider);
        final result = await usecase.call(harvestId: item.id, pickupTime: '14:00');

        result.fold(
          (failure) {},
          (success) {},
        );
      },
      orElse: () {},
    );
  }
}
