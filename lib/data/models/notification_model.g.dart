// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationReferenceModel _$NotificationReferenceModelFromJson(
        Map<String, dynamic> json) =>
    NotificationReferenceModel(
      type: json['type'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$NotificationReferenceModelToJson(
        NotificationReferenceModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };

NotificationActionModel _$NotificationActionModelFromJson(
        Map<String, dynamic> json) =>
    NotificationActionModel(
      type: json['type'] as String,
      screen: json['screen'] as String,
      params: json['params'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationActionModelToJson(
        NotificationActionModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'screen': instance.screen,
      'params': instance.params,
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notificationId: json['notification_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String?,
      reference: json['reference'] == null
          ? null
          : NotificationReferenceModel.fromJson(
              json['reference'] as Map<String, dynamic>),
      action: json['action'] == null
          ? null
          : NotificationActionModel.fromJson(
              json['action'] as Map<String, dynamic>),
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
      priority: json['priority'] as String,
      expiresAt: json['expires_at'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'icon': instance.icon,
      'image': instance.image,
      'reference': instance.reference,
      'action': instance.action,
      'is_read': instance.isRead,
      'read_at': instance.readAt,
      'priority': instance.priority,
      'expires_at': instance.expiresAt,
      'created_at': instance.createdAt,
    };

NotificationStatsModel _$NotificationStatsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationStatsModel(
      totalUnread: (json['total_unread'] as num).toInt(),
      byType: Map<String, int>.from(json['by_type'] as Map),
    );

Map<String, dynamic> _$NotificationStatsModelToJson(
        NotificationStatsModel instance) =>
    <String, dynamic>{
      'total_unread': instance.totalUnread,
      'by_type': instance.byType,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      itemsPerPage: (json['items_per_page'] as num).toInt(),
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'total_items': instance.totalItems,
      'items_per_page': instance.itemsPerPage,
      'has_next': instance.hasNext,
      'has_previous': instance.hasPrevious,
    };

NotificationListModel _$NotificationListModelFromJson(
        Map<String, dynamic> json) =>
    NotificationListModel(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: NotificationStatsModel.fromJson(
          json['stats'] as Map<String, dynamic>),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationListModelToJson(
        NotificationListModel instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'stats': instance.stats,
      'pagination': instance.pagination,
    };

PushNotificationSettingsModel _$PushNotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    PushNotificationSettingsModel(
      enabled: json['enabled'] as bool,
      orderUpdates: json['order_updates'] as bool,
      messages: json['messages'] as bool,
      promotions: json['promotions'] as bool,
      priceAlerts: json['price_alerts'] as bool,
      stockAlerts: json['stock_alerts'] as bool,
      systemUpdates: json['system_updates'] as bool,
      newFollowers: json['new_followers'] as bool,
      reviews: json['reviews'] as bool,
    );

Map<String, dynamic> _$PushNotificationSettingsModelToJson(
        PushNotificationSettingsModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'order_updates': instance.orderUpdates,
      'messages': instance.messages,
      'promotions': instance.promotions,
      'price_alerts': instance.priceAlerts,
      'stock_alerts': instance.stockAlerts,
      'system_updates': instance.systemUpdates,
      'new_followers': instance.newFollowers,
      'reviews': instance.reviews,
    };

EmailNotificationSettingsModel _$EmailNotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    EmailNotificationSettingsModel(
      enabled: json['enabled'] as bool,
      orderUpdates: json['order_updates'] as bool,
      messages: json['messages'] as bool,
      promotions: json['promotions'] as bool,
      weeklySummary: json['weekly_summary'] as bool,
      monthlyReport: json['monthly_report'] as bool,
    );

Map<String, dynamic> _$EmailNotificationSettingsModelToJson(
        EmailNotificationSettingsModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'order_updates': instance.orderUpdates,
      'messages': instance.messages,
      'promotions': instance.promotions,
      'weekly_summary': instance.weeklySummary,
      'monthly_report': instance.monthlyReport,
    };

SmsNotificationSettingsModel _$SmsNotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    SmsNotificationSettingsModel(
      enabled: json['enabled'] as bool,
      orderUpdates: json['order_updates'] as bool,
      paymentConfirmations: json['payment_confirmations'] as bool,
    );

Map<String, dynamic> _$SmsNotificationSettingsModelToJson(
        SmsNotificationSettingsModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'order_updates': instance.orderUpdates,
      'payment_confirmations': instance.paymentConfirmations,
    };

InAppNotificationSettingsModel _$InAppNotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    InAppNotificationSettingsModel(
      enabled: json['enabled'] as bool,
      sound: json['sound'] as bool,
      vibration: json['vibration'] as bool,
      badge: json['badge'] as bool,
    );

Map<String, dynamic> _$InAppNotificationSettingsModelToJson(
        InAppNotificationSettingsModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'sound': instance.sound,
      'vibration': instance.vibration,
      'badge': instance.badge,
    };

QuietHoursModel _$QuietHoursModelFromJson(Map<String, dynamic> json) =>
    QuietHoursModel(
      enabled: json['enabled'] as bool,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$QuietHoursModelToJson(QuietHoursModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'timezone': instance.timezone,
    };

NotificationSettingsModel _$NotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsModel(
      pushNotifications: PushNotificationSettingsModel.fromJson(
          json['push_notifications'] as Map<String, dynamic>),
      emailNotifications: EmailNotificationSettingsModel.fromJson(
          json['email_notifications'] as Map<String, dynamic>),
      smsNotifications: SmsNotificationSettingsModel.fromJson(
          json['sms_notifications'] as Map<String, dynamic>),
      inAppNotifications: InAppNotificationSettingsModel.fromJson(
          json['in_app_notifications'] as Map<String, dynamic>),
      quietHours: json['quiet_hours'] == null
          ? null
          : QuietHoursModel.fromJson(
              json['quiet_hours'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationSettingsModelToJson(
        NotificationSettingsModel instance) =>
    <String, dynamic>{
      'push_notifications': instance.pushNotifications,
      'email_notifications': instance.emailNotifications,
      'sms_notifications': instance.smsNotifications,
      'in_app_notifications': instance.inAppNotifications,
      'quiet_hours': instance.quietHours,
    };

MarkReadResultModel _$MarkReadResultModelFromJson(Map<String, dynamic> json) =>
    MarkReadResultModel(
      notificationId: json['notification_id'] as String,
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String,
    );

Map<String, dynamic> _$MarkReadResultModelToJson(
        MarkReadResultModel instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'is_read': instance.isRead,
      'read_at': instance.readAt,
    };

MarkAllReadResultModel _$MarkAllReadResultModelFromJson(
        Map<String, dynamic> json) =>
    MarkAllReadResultModel(
      markedCount: (json['marked_count'] as num).toInt(),
      markedAt: json['marked_at'] as String,
    );

Map<String, dynamic> _$MarkAllReadResultModelToJson(
        MarkAllReadResultModel instance) =>
    <String, dynamic>{
      'marked_count': instance.markedCount,
      'marked_at': instance.markedAt,
    };

ClearNotificationsResultModel _$ClearNotificationsResultModelFromJson(
        Map<String, dynamic> json) =>
    ClearNotificationsResultModel(
      deletedCount: (json['deleted_count'] as num).toInt(),
    );

Map<String, dynamic> _$ClearNotificationsResultModelToJson(
        ClearNotificationsResultModel instance) =>
    <String, dynamic>{
      'deleted_count': instance.deletedCount,
    };
