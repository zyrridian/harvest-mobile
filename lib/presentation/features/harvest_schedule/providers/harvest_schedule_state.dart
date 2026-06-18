import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';

part 'harvest_schedule_state.freezed.dart';

enum QuickFilter { thisWeek, readyToday, thisMonth }

class HarvestScheduleData {
  final int thisWeekCount;
  final int readyTodayCount;
  final int thisMonthCount;
  final List<HarvestScheduleItemEntity> items;
  final DateTime baseDate;
  final DateTime? selectedDate;
  final bool isMonthView;
  final QuickFilter? activeQuickFilter;

  HarvestScheduleData({
    required this.thisWeekCount,
    required this.readyTodayCount,
    required this.thisMonthCount,
    required this.items,
    required this.baseDate,
    this.selectedDate,
    this.isMonthView = false,
    this.activeQuickFilter,
  });

  factory HarvestScheduleData.fromEntity(
    HarvestScheduleDashboardEntity entity, {
    required DateTime baseDate,
    DateTime? selectedDate,
    bool isMonthView = false,
    QuickFilter? activeQuickFilter,
  }) {
    return HarvestScheduleData(
      thisWeekCount: entity.thisWeekCount,
      readyTodayCount: entity.readyTodayCount,
      thisMonthCount: entity.thisMonthCount,
      items: entity.items,
      baseDate: baseDate,
      selectedDate: selectedDate,
      isMonthView: isMonthView,
      activeQuickFilter: activeQuickFilter,
    );
  }

  HarvestScheduleData copyWith({
    int? thisWeekCount,
    int? readyTodayCount,
    int? thisMonthCount,
    List<HarvestScheduleItemEntity>? items,
    DateTime? baseDate,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    bool? isMonthView,
    QuickFilter? activeQuickFilter,
    bool clearQuickFilter = false,
  }) {
    return HarvestScheduleData(
      thisWeekCount: thisWeekCount ?? this.thisWeekCount,
      readyTodayCount: readyTodayCount ?? this.readyTodayCount,
      thisMonthCount: thisMonthCount ?? this.thisMonthCount,
      items: items ?? this.items,
      baseDate: baseDate ?? this.baseDate,
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      isMonthView: isMonthView ?? this.isMonthView,
      activeQuickFilter: clearQuickFilter ? null : (activeQuickFilter ?? this.activeQuickFilter),
    );
  }

  List<HarvestScheduleItemEntity> get filteredItems {
    if (activeQuickFilter != null) {
      switch (activeQuickFilter!) {
        case QuickFilter.readyToday:
          return items.where((i) => i.isToday).toList();
        case QuickFilter.thisMonth:
          return items;
        case QuickFilter.thisWeek:
          // A simple approach: assume current week contains today. For a real app,
          // calculate start/end of the current week from DateTime.now() and filter items.
          // Since the dummy data's 'dateDayFilter' is just a string of the day,
          // let's grab the days for the current week and filter.
          final now = DateTime.now();
          int offset = now.weekday == 7 ? 0 : now.weekday;
          DateTime startOfWeek = now.subtract(Duration(days: offset));
          final weekDays = List.generate(7, (index) => startOfWeek.add(Duration(days: index)).day.toString());
          return items.where((i) => weekDays.contains(i.dateDayFilter)).toList();
      }
    }

    if (selectedDate == null) return items;
    final dayStr = selectedDate!.day.toString();
    return items.where((i) => i.dateDayFilter == dayStr).toList();
  }
}

@freezed
class HarvestScheduleState with _$HarvestScheduleState {
  const factory HarvestScheduleState.initial() = _Initial;
  const factory HarvestScheduleState.loading() = _Loading;
  const factory HarvestScheduleState.data(HarvestScheduleData data) = _Data;
  const factory HarvestScheduleState.error(String message) = _Error;
}
