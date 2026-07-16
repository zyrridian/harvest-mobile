import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/notification.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationReferenceModel {
  final String type;
  final String id;

  NotificationReferenceModel({
    required this.type,
    required this.id,
  });

  factory NotificationReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationReferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationReferenceModelToJson(this);

  NotificationReference toEntity() {
    return NotificationReference(
      type: type,
      id: id,
    );
  }

  factory NotificationReferenceModel.fromEntity(NotificationReference entity) {
    return NotificationReferenceModel(
      type: entity.type,
      id: entity.id,
    );
  }
}

@JsonSerializable()
class NotificationActionModel {
  final String type;
  final String screen;
  final Map<String, dynamic>? params;

  NotificationActionModel({
    required this.type,
    required this.screen,
    this.params,
  });

  factory NotificationActionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationActionModelToJson(this);

  NotificationAction toEntity() {
    return NotificationAction(
      type: type,
      screen: screen,
      params: params,
    );
  }

  factory NotificationActionModel.fromEntity(NotificationAction entity) {
    return NotificationActionModel(
      type: entity.type,
      screen: entity.screen,
      params: entity.params,
    );
  }
}

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: 'notification_id')
  final String notificationId;

  final String type;
  final String title;
  final String message;
  final String icon;
  final String? image;

  final NotificationReferenceModel? reference;
  final NotificationActionModel? action;

  @JsonKey(name: 'is_read')
  final bool isRead;

  @JsonKey(name: 'read_at')
  final String? readAt;

  final String priority;

  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  NotificationModel({
    required this.notificationId,
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    this.image,
    this.reference,
    this.action,
    required this.isRead,
    this.readAt,
    required this.priority,
    this.expiresAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  AppNotification toEntity() {
    return AppNotification(
      notificationId: notificationId,
      type: _parseNotificationType(type),
      title: title,
      message: message,
      icon: icon,
      image: image,
      reference: reference?.toEntity(),
      action: action?.toEntity(),
      isRead: isRead,
      readAt: readAt != null ? DateTime.parse(readAt!) : null,
      priority: _parsePriority(priority),
      expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : null,
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory NotificationModel.fromEntity(AppNotification entity) {
    return NotificationModel(
      notificationId: entity.notificationId,
      type: entity.type.name,
      title: entity.title,
      message: entity.message,
      icon: entity.icon,
      image: entity.image,
      reference: entity.reference != null
          ? NotificationReferenceModel.fromEntity(entity.reference!)
          : null,
      action: entity.action != null
          ? NotificationActionModel.fromEntity(entity.action!)
          : null,
      isRead: entity.isRead,
      readAt: entity.readAt?.toIso8601String(),
      priority: entity.priority.name,
      expiresAt: entity.expiresAt?.toIso8601String(),
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'order':
        return NotificationType.order;
      case 'message':
        return NotificationType.message;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      case 'price_alert':
        return NotificationType.priceAlert;
      case 'stock_alert':
        return NotificationType.stockAlert;
      default:
        return NotificationType.system;
    }
  }

  static NotificationPriority _parsePriority(String priority) {
    switch (priority) {
      case 'low':
        return NotificationPriority.low;
      case 'medium':
        return NotificationPriority.medium;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.medium;
    }
  }
}

@JsonSerializable()
class NotificationStatsModel {
  @JsonKey(name: 'total_unread')
  final int totalUnread;

  @JsonKey(name: 'by_type')
  final Map<String, int> byType;

  NotificationStatsModel({
    required this.totalUnread,
    required this.byType,
  });

  factory NotificationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationStatsModelToJson(this);

  NotificationStats toEntity() {
    return NotificationStats(
      totalUnread: totalUnread,
      byType: byType,
    );
  }
}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'total_items')
  final int totalItems;

  @JsonKey(name: 'items_per_page')
  final int itemsPerPage;

  @JsonKey(name: 'has_next')
  final bool hasNext;

  @JsonKey(name: 'has_previous')
  final bool hasPrevious;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}

@JsonSerializable()
class NotificationListModel {
  final List<NotificationModel> notifications;
  final NotificationStatsModel stats;
  final PaginationModel pagination;

  NotificationListModel({
    required this.notifications,
    required this.stats,
    required this.pagination,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationListModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListModelToJson(this);

  NotificationList toEntity() {
    return NotificationList(
      notifications: notifications.map((n) => n.toEntity()).toList(),
      stats: stats.toEntity(),
      currentPage: pagination.currentPage,
      totalPages: pagination.totalPages,
      totalItems: pagination.totalItems,
      itemsPerPage: pagination.itemsPerPage,
      hasNext: pagination.hasNext,
      hasPrevious: pagination.hasPrevious,
    );
  }
}

@JsonSerializable()
class PushNotificationSettingsModel {
  final bool enabled;

  @JsonKey(name: 'order_updates')
  final bool orderUpdates;

  final bool messages;
  final bool promotions;

  @JsonKey(name: 'price_alerts')
  final bool priceAlerts;

  @JsonKey(name: 'stock_alerts')
  final bool stockAlerts;

  @JsonKey(name: 'system_updates')
  final bool systemUpdates;

  @JsonKey(name: 'new_followers')
  final bool newFollowers;

  final bool reviews;

  PushNotificationSettingsModel({
    required this.enabled,
    required this.orderUpdates,
    required this.messages,
    required this.promotions,
    required this.priceAlerts,
    required this.stockAlerts,
    required this.systemUpdates,
    required this.newFollowers,
    required this.reviews,
  });

  factory PushNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationSettingsModelToJson(this);

  PushNotificationSettings toEntity() {
    return PushNotificationSettings(
      enabled: enabled,
      orderUpdates: orderUpdates,
      messages: messages,
      promotions: promotions,
      priceAlerts: priceAlerts,
      stockAlerts: stockAlerts,
      systemUpdates: systemUpdates,
      newFollowers: newFollowers,
      reviews: reviews,
    );
  }
}

@JsonSerializable()
class EmailNotificationSettingsModel {
  final bool enabled;

  @JsonKey(name: 'order_updates')
  final bool orderUpdates;

  final bool messages;
  final bool promotions;

  @JsonKey(name: 'weekly_summary')
  final bool weeklySummary;

  @JsonKey(name: 'monthly_report')
  final bool monthlyReport;

  EmailNotificationSettingsModel({
    required this.enabled,
    required this.orderUpdates,
    required this.messages,
    required this.promotions,
    required this.weeklySummary,
    required this.monthlyReport,
  });

  factory EmailNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmailNotificationSettingsModelToJson(this);

  EmailNotificationSettings toEntity() {
    return EmailNotificationSettings(
      enabled: enabled,
      orderUpdates: orderUpdates,
      messages: messages,
      promotions: promotions,
      weeklySummary: weeklySummary,
      monthlyReport: monthlyReport,
    );
  }
}

@JsonSerializable()
class SmsNotificationSettingsModel {
  final bool enabled;

  @JsonKey(name: 'order_updates')
  final bool orderUpdates;

  @JsonKey(name: 'payment_confirmations')
  final bool paymentConfirmations;

  SmsNotificationSettingsModel({
    required this.enabled,
    required this.orderUpdates,
    required this.paymentConfirmations,
  });

  factory SmsNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SmsNotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmsNotificationSettingsModelToJson(this);

  SmsNotificationSettings toEntity() {
    return SmsNotificationSettings(
      enabled: enabled,
      orderUpdates: orderUpdates,
      paymentConfirmations: paymentConfirmations,
    );
  }
}

@JsonSerializable()
class InAppNotificationSettingsModel {
  final bool enabled;
  final bool sound;
  final bool vibration;
  final bool badge;

  InAppNotificationSettingsModel({
    required this.enabled,
    required this.sound,
    required this.vibration,
    required this.badge,
  });

  factory InAppNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$InAppNotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$InAppNotificationSettingsModelToJson(this);

  InAppNotificationSettings toEntity() {
    return InAppNotificationSettings(
      enabled: enabled,
      sound: sound,
      vibration: vibration,
      badge: badge,
    );
  }
}

@JsonSerializable()
class QuietHoursModel {
  final bool enabled;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  final String timezone;

  QuietHoursModel({
    required this.enabled,
    required this.startTime,
    required this.endTime,
    required this.timezone,
  });

  factory QuietHoursModel.fromJson(Map<String, dynamic> json) =>
      _$QuietHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuietHoursModelToJson(this);

  QuietHours toEntity() {
    return QuietHours(
      enabled: enabled,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }
}

@JsonSerializable()
class NotificationSettingsModel {
  @JsonKey(name: 'push_notifications')
  final PushNotificationSettingsModel pushNotifications;

  @JsonKey(name: 'email_notifications')
  final EmailNotificationSettingsModel emailNotifications;

  @JsonKey(name: 'sms_notifications')
  final SmsNotificationSettingsModel smsNotifications;

  @JsonKey(name: 'in_app_notifications')
  final InAppNotificationSettingsModel inAppNotifications;

  @JsonKey(name: 'quiet_hours')
  final QuietHoursModel? quietHours;

  NotificationSettingsModel({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.inAppNotifications,
    this.quietHours,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsModelToJson(this);

  NotificationSettings toEntity() {
    return NotificationSettings(
      pushNotifications: pushNotifications.toEntity(),
      emailNotifications: emailNotifications.toEntity(),
      smsNotifications: smsNotifications.toEntity(),
      inAppNotifications: inAppNotifications.toEntity(),
      quietHours: quietHours?.toEntity(),
    );
  }
}

@JsonSerializable()
class MarkReadResultModel {
  @JsonKey(name: 'notification_id')
  final String notificationId;

  @JsonKey(name: 'is_read')
  final bool isRead;

  @JsonKey(name: 'read_at')
  final String readAt;

  MarkReadResultModel({
    required this.notificationId,
    required this.isRead,
    required this.readAt,
  });

  factory MarkReadResultModel.fromJson(Map<String, dynamic> json) =>
      _$MarkReadResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarkReadResultModelToJson(this);

  MarkReadResult toEntity() {
    return MarkReadResult(
      notificationId: notificationId,
      isRead: isRead,
      readAt: DateTime.parse(readAt),
    );
  }
}

@JsonSerializable()
class MarkAllReadResultModel {
  @JsonKey(name: 'marked_count')
  final int markedCount;

  @JsonKey(name: 'marked_at')
  final String markedAt;

  MarkAllReadResultModel({
    required this.markedCount,
    required this.markedAt,
  });

  factory MarkAllReadResultModel.fromJson(Map<String, dynamic> json) =>
      _$MarkAllReadResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarkAllReadResultModelToJson(this);

  MarkAllReadResult toEntity() {
    return MarkAllReadResult(
      markedCount: markedCount,
      markedAt: DateTime.parse(markedAt),
    );
  }
}

@JsonSerializable()
class ClearNotificationsResultModel {
  @JsonKey(name: 'deleted_count')
  final int deletedCount;

  ClearNotificationsResultModel({required this.deletedCount});

  factory ClearNotificationsResultModel.fromJson(Map<String, dynamic> json) =>
      _$ClearNotificationsResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClearNotificationsResultModelToJson(this);

  ClearNotificationsResult toEntity() {
    return ClearNotificationsResult(deletedCount: deletedCount);
  }
}
