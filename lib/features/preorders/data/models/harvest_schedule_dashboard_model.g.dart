// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_schedule_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarvestScheduleDashboardModel _$HarvestScheduleDashboardModelFromJson(
        Map<String, dynamic> json) =>
    HarvestScheduleDashboardModel(
      thisWeekCount: (json['this_week_count'] as num).toInt(),
      readyTodayCount: (json['ready_today_count'] as num).toInt(),
      thisMonthCount: (json['this_month_count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              HarvestScheduleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HarvestScheduleDashboardModelToJson(
        HarvestScheduleDashboardModel instance) =>
    <String, dynamic>{
      'this_week_count': instance.thisWeekCount,
      'ready_today_count': instance.readyTodayCount,
      'this_month_count': instance.thisMonthCount,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

HarvestScheduleItemModel _$HarvestScheduleItemModelFromJson(
        Map<String, dynamic> json) =>
    HarvestScheduleItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      farmerName: json['farmer_name'] as String,
      distance: (json['distance'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      statusText: json['status_text'] as String,
      price: (json['price'] as num).toDouble(),
      badges:
          (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
      descriptionText: json['description_text'] as String,
      actionButton1: json['action_button_1'] as String,
      actionButton2: json['action_button_2'] as String,
      dateGroup: json['date_group'] as String,
      isToday: json['is_today'] as bool? ?? false,
      dateDayFilter: json['date_day_filter'] as String,
    );

Map<String, dynamic> _$HarvestScheduleItemModelToJson(
        HarvestScheduleItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'farmer_name': instance.farmerName,
      'distance': instance.distance,
      'image_url': instance.imageUrl,
      'status_text': instance.statusText,
      'price': instance.price,
      'badges': instance.badges,
      'description_text': instance.descriptionText,
      'action_button_1': instance.actionButton1,
      'action_button_2': instance.actionButton2,
      'date_group': instance.dateGroup,
      'is_today': instance.isToday,
      'date_day_filter': instance.dateDayFilter,
    };
