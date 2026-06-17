import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';

part 'harvest_schedule_state.freezed.dart';

class HarvestScheduleData {
  final int thisWeekCount;
  final int readyTodayCount;
  final int thisMonthCount;
  final List<HarvestScheduleItemEntity> items;
  final String? selectedDateFilter;

  HarvestScheduleData({
    required this.thisWeekCount,
    required this.readyTodayCount,
    required this.thisMonthCount,
    required this.items,
    this.selectedDateFilter,
  });

  factory HarvestScheduleData.fromEntity(
      HarvestScheduleDashboardEntity entity, {String? selectedDateFilter}) {
    return HarvestScheduleData(
      thisWeekCount: entity.thisWeekCount,
      readyTodayCount: entity.readyTodayCount,
      thisMonthCount: entity.thisMonthCount,
      items: entity.items,
      selectedDateFilter: selectedDateFilter,
    );
  }

  HarvestScheduleData copyWith({
    int? thisWeekCount,
    int? readyTodayCount,
    int? thisMonthCount,
    List<HarvestScheduleItemEntity>? items,
    String? selectedDateFilter,
    bool clearFilter = false,
  }) {
    return HarvestScheduleData(
      thisWeekCount: thisWeekCount ?? this.thisWeekCount,
      readyTodayCount: readyTodayCount ?? this.readyTodayCount,
      thisMonthCount: thisMonthCount ?? this.thisMonthCount,
      items: items ?? this.items,
      selectedDateFilter:
          clearFilter ? null : (selectedDateFilter ?? this.selectedDateFilter),
    );
  }

  List<HarvestScheduleItemEntity> get filteredItems {
    if (selectedDateFilter == null) return items;
    return items.where((i) => i.dateDayFilter == selectedDateFilter).toList();
  }
}

@freezed
class HarvestScheduleState with _$HarvestScheduleState {
  const factory HarvestScheduleState.initial() = _Initial;
  const factory HarvestScheduleState.loading() = _Loading;
  const factory HarvestScheduleState.data(HarvestScheduleData data) = _Data;
  const factory HarvestScheduleState.error(String message) = _Error;
}
