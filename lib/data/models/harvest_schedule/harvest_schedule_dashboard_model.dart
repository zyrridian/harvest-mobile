import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harvest_schedule_dashboard_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HarvestScheduleDashboardModel {
  @JsonKey(name: 'this_week_count')
  final int thisWeekCount;
  @JsonKey(name: 'ready_today_count')
  final int readyTodayCount;
  @JsonKey(name: 'this_month_count')
  final int thisMonthCount;
  final List<HarvestScheduleItemModel> items;

  HarvestScheduleDashboardModel({
    required this.thisWeekCount,
    required this.readyTodayCount,
    required this.thisMonthCount,
    required this.items,
  });

  factory HarvestScheduleDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$HarvestScheduleDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$HarvestScheduleDashboardModelToJson(this);

  HarvestScheduleDashboardEntity toEntity() {
    return HarvestScheduleDashboardEntity(
      thisWeekCount: thisWeekCount,
      readyTodayCount: readyTodayCount,
      thisMonthCount: thisMonthCount,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }

  factory HarvestScheduleDashboardModel.fromEntity(
      HarvestScheduleDashboardEntity entity) {
    return HarvestScheduleDashboardModel(
      thisWeekCount: entity.thisWeekCount,
      readyTodayCount: entity.readyTodayCount,
      thisMonthCount: entity.thisMonthCount,
      items: entity.items
          .map((e) => HarvestScheduleItemModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class HarvestScheduleItemModel {
  final String id;
  final String title;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  final double distance;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'status_text')
  final String statusText;
  final double price;
  final List<String> badges;
  @JsonKey(name: 'description_text')
  final String descriptionText;
  @JsonKey(name: 'action_button_1')
  final String actionButton1;
  @JsonKey(name: 'action_button_2')
  final String actionButton2;
  @JsonKey(name: 'date_group')
  final String dateGroup;
  @JsonKey(name: 'is_today', defaultValue: false)
  final bool isToday;
  @JsonKey(name: 'date_day_filter')
  final String dateDayFilter;

  HarvestScheduleItemModel({
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
    required this.isToday,
    required this.dateDayFilter,
  });

  factory HarvestScheduleItemModel.fromJson(Map<String, dynamic> json) =>
      _$HarvestScheduleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$HarvestScheduleItemModelToJson(this);

  HarvestScheduleItemEntity toEntity() {
    return HarvestScheduleItemEntity(
      id: id,
      title: title,
      farmerName: farmerName,
      distance: distance,
      imageUrl: imageUrl,
      statusText: statusText,
      price: price,
      badges: badges,
      descriptionText: descriptionText,
      actionButton1: actionButton1,
      actionButton2: actionButton2,
      dateGroup: dateGroup,
      isToday: isToday,
      dateDayFilter: dateDayFilter,
    );
  }

  factory HarvestScheduleItemModel.fromEntity(HarvestScheduleItemEntity entity) {
    return HarvestScheduleItemModel(
      id: entity.id,
      title: entity.title,
      farmerName: entity.farmerName,
      distance: entity.distance,
      imageUrl: entity.imageUrl,
      statusText: entity.statusText,
      price: entity.price,
      badges: entity.badges,
      descriptionText: entity.descriptionText,
      actionButton1: entity.actionButton1,
      actionButton2: entity.actionButton2,
      dateGroup: entity.dateGroup,
      isToday: entity.isToday,
      dateDayFilter: entity.dateDayFilter,
    );
  }
}
