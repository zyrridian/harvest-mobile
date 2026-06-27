import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';
import 'package:harvest_app/features/preorders/data/datasources/remote/harvest_schedule_remote_datasource.dart';
import 'package:harvest_app/data/repositories/harvest_schedule_repository_impl.dart';
import 'package:harvest_app/domain/repositories/harvest_schedule_repository.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/get_harvest_schedule_usecase.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/pay_deposit_usecase.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/arrange_pickup_usecase.dart';
import 'package:harvest_app/domain/usecases/harvest_schedule/get_schedule_dashboard_usecase.dart';
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

final getScheduleDashboardUseCaseProvider = Provider<GetScheduleDashboardUseCase>((ref) {
  return GetScheduleDashboardUseCase(ref.watch(harvestScheduleRepositoryProvider));
});

@riverpod
class HarvestScheduleController extends _$HarvestScheduleController {
  @override
  HarvestScheduleState build() {
    final now = DateTime.now();
    Future.microtask(() => _fetchData(now));
    return const HarvestScheduleState.loading();
  }

  Future<void> _fetchData(DateTime date, {DateTime? selectedDate, bool? isMonthView}) async {
    final oldData = state.maybeWhen(data: (d) => d, orElse: () => null);

    if (oldData == null) {
      state = const HarvestScheduleState.loading();
    }

    try {
      final usecase = ref.read(getHarvestScheduleUseCaseProvider);
      final dashboardUseCase = ref.read(getScheduleDashboardUseCaseProvider);
      
      final monthStr = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      
      final result = await usecase.call(month: monthStr);
      final dashboardResult = await dashboardUseCase.call(month: monthStr);

      result.fold(
        (failure) {
          state = HarvestScheduleState.error(failure.message);
        },
        (entity) {
          // If dashboardResult is successful, we can optionally merge the data into entity, 
          // but for now we just use entity from getHarvestScheduleUseCase and ignore failure of the new endpoint
          
          state = HarvestScheduleState.data(HarvestScheduleData.fromEntity(
            entity,
            baseDate: date,
            selectedDate: selectedDate ?? date,
            isMonthView: isMonthView ?? oldData?.isMonthView ?? false,
          ));
        },
      );
    } catch (e) {
      state = HarvestScheduleState.error(e.toString());
    }
  }

  void toggleViewMode() {
    state.maybeWhen(
      data: (data) {
        state = HarvestScheduleState.data(data.copyWith(isMonthView: !data.isMonthView));
      },
      orElse: () {},
    );
  }

  void toggleDateFilter(DateTime date) {
    state.maybeWhen(
      data: (data) {
        if (data.selectedDate?.year == date.year &&
            data.selectedDate?.month == date.month &&
            data.selectedDate?.day == date.day) {
          // Deselect
          state = HarvestScheduleState.data(data.copyWith(clearSelectedDate: true));
        } else {
          // Select
          state = HarvestScheduleState.data(data.copyWith(
            selectedDate: date,
            clearQuickFilter: true,
          ));
        }
      },
      orElse: () {},
    );
  }

  void toggleQuickFilter(QuickFilter filter) {
    state.maybeWhen(
      data: (data) {
        if (data.activeQuickFilter == filter) {
          // Deselect
          state = HarvestScheduleState.data(data.copyWith(clearQuickFilter: true));
        } else {
          // Select
          state = HarvestScheduleState.data(data.copyWith(
            activeQuickFilter: filter,
            clearSelectedDate: true,
          ));
        }
      },
      orElse: () {},
    );
  }

  void next() {
    state.maybeWhen(
      data: (data) {
        DateTime newBaseDate;
        if (data.isMonthView) {
          newBaseDate = DateTime(data.baseDate.year, data.baseDate.month + 1, data.baseDate.day);
        } else {
          newBaseDate = data.baseDate.add(const Duration(days: 7));
        }
        
        if (newBaseDate.month != data.baseDate.month || newBaseDate.year != data.baseDate.year) {
          _fetchData(newBaseDate, selectedDate: data.selectedDate, isMonthView: data.isMonthView);
        } else {
          state = HarvestScheduleState.data(data.copyWith(baseDate: newBaseDate));
        }
      },
      orElse: () {},
    );
  }

  void previous() {
    state.maybeWhen(
      data: (data) {
        DateTime newBaseDate;
        if (data.isMonthView) {
          newBaseDate = DateTime(data.baseDate.year, data.baseDate.month - 1, data.baseDate.day);
        } else {
          newBaseDate = data.baseDate.subtract(const Duration(days: 7));
        }
        
        if (newBaseDate.month != data.baseDate.month || newBaseDate.year != data.baseDate.year) {
          _fetchData(newBaseDate, selectedDate: data.selectedDate, isMonthView: data.isMonthView);
        } else {
          state = HarvestScheduleState.data(data.copyWith(baseDate: newBaseDate));
        }
      },
      orElse: () {},
    );
  }

  void goToToday() {
    final now = DateTime.now();
    state.maybeWhen(
      data: (data) {
        if (now.month != data.baseDate.month || now.year != data.baseDate.year) {
          _fetchData(now, selectedDate: now, isMonthView: data.isMonthView);
        } else {
          state = HarvestScheduleState.data(data.copyWith(
            baseDate: now,
            selectedDate: now,
            clearSelectedDate: false,
          ));
        }
      },
      orElse: () {
        Future.microtask(() => _fetchData(now));
      },
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
