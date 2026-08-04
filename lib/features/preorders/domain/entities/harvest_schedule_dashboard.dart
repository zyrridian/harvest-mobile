import 'package:equatable/equatable.dart';

class HarvestScheduleItemEntity extends Equatable {
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
  final String dateDayFilter; // Used for UI filtering e.g. '13' or '16'

  const HarvestScheduleItemEntity({
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
    required this.dateDayFilter,
    this.isToday = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        farmerName,
        distance,
        imageUrl,
        statusText,
        price,
        badges,
        descriptionText,
        actionButton1,
        actionButton2,
        dateGroup,
        dateDayFilter,
        isToday,
      ];
}

class HarvestScheduleDashboardEntity extends Equatable {
  final int thisWeekCount;
  final int readyTodayCount;
  final int thisMonthCount;
  final List<HarvestScheduleItemEntity> items;

  const HarvestScheduleDashboardEntity({
    required this.thisWeekCount,
    required this.readyTodayCount,
    required this.thisMonthCount,
    required this.items,
  });

  @override
  List<Object?> get props => [
        thisWeekCount,
        readyTodayCount,
        thisMonthCount,
        items,
      ];
}
