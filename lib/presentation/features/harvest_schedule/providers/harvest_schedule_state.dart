import 'package:freezed_annotation/freezed_annotation.dart';

part 'harvest_schedule_state.freezed.dart';

class HarvestScheduleItem {
  final String id;
  final String title;
  final String farmerName;
  final double distance;
  final String imageUrl;
  final String statusText;
  final double price;
  final List<String> badges;
  final String descriptionText;
  final String actionButton1;
  final String actionButton2;
  final String dateGroup;
  final bool isToday;

  HarvestScheduleItem({
    required this.id,
    required this.title,
    required this.farmerName,
    required this.distance,
    required this.imageUrl,
    required this.statusText,
    required this.price,
    required this.badges,
    required this.descriptionText,
    required this.actionButton1,
    required this.actionButton2,
    required this.dateGroup,
    this.isToday = false,
  });
}

class HarvestScheduleData {
  final int thisWeekCount;
  final int readyTodayCount;
  final int thisMonthCount;
  final List<HarvestScheduleItem> items;

  HarvestScheduleData({
    required this.thisWeekCount,
    required this.readyTodayCount,
    required this.thisMonthCount,
    required this.items,
  });
}

@freezed
class HarvestScheduleState with _$HarvestScheduleState {
  const factory HarvestScheduleState.initial() = _Initial;
  const factory HarvestScheduleState.loading() = _Loading;
  const factory HarvestScheduleState.data(HarvestScheduleData data) = _Data;
  const factory HarvestScheduleState.error(String message) = _Error;
}
