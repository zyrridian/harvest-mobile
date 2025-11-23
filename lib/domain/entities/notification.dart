import 'package:equatable/equatable.dart';

enum NotificationType {
  order,
  message,
  promotion,
  system,
  priceAlert,
  stockAlert,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

class NotificationReference extends Equatable {
  final String type; // order, conversation, product, promotion
  final String id;

  const NotificationReference({
    required this.type,
    required this.id,
  });

  @override
  List<Object?> get props => [type, id];
}

class NotificationAction extends Equatable {
  final String type; // navigate
  final String screen; // order_detail, chat, product_detail, etc.
  final Map<String, dynamic>? params;

  const NotificationAction({
    required this.type,
    required this.screen,
    this.params,
  });

  @override
  List<Object?> get props => [type, screen, params];
}

class AppNotification extends Equatable {
  final String notificationId;
  final NotificationType type;
  final String title;
  final String message;
  final String icon;
  final String? image;
  final NotificationReference? reference;
  final NotificationAction? action;
  final bool isRead;
  final DateTime? readAt;
  final NotificationPriority priority;
  final DateTime? expiresAt;
  final DateTime createdAt;

  const AppNotification({
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

  @override
  List<Object?> get props => [
        notificationId,
        type,
        title,
        message,
        icon,
        image,
        reference,
        action,
        isRead,
        readAt,
        priority,
        expiresAt,
        createdAt,
      ];
}

class NotificationStats extends Equatable {
  final int totalUnread;
  final Map<String, int> byType;

  const NotificationStats({
    required this.totalUnread,
    required this.byType,
  });

  @override
  List<Object?> get props => [totalUnread, byType];
}

class NotificationList extends Equatable {
  final List<AppNotification> notifications;
  final NotificationStats stats;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrevious;

  const NotificationList({
    required this.notifications,
    required this.stats,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  @override
  List<Object?> get props => [
        notifications,
        stats,
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        hasNext,
        hasPrevious,
      ];
}

class NotificationSettings extends Equatable {
  final PushNotificationSettings pushNotifications;
  final EmailNotificationSettings emailNotifications;
  final SmsNotificationSettings smsNotifications;
  final InAppNotificationSettings inAppNotifications;
  final QuietHours? quietHours;

  const NotificationSettings({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.inAppNotifications,
    this.quietHours,
  });

  @override
  List<Object?> get props => [
        pushNotifications,
        emailNotifications,
        smsNotifications,
        inAppNotifications,
        quietHours,
      ];
}

class PushNotificationSettings extends Equatable {
  final bool enabled;
  final bool orderUpdates;
  final bool messages;
  final bool promotions;
  final bool priceAlerts;
  final bool stockAlerts;
  final bool systemUpdates;
  final bool newFollowers;
  final bool reviews;

  const PushNotificationSettings({
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

  @override
  List<Object?> get props => [
        enabled,
        orderUpdates,
        messages,
        promotions,
        priceAlerts,
        stockAlerts,
        systemUpdates,
        newFollowers,
        reviews,
      ];
}

class EmailNotificationSettings extends Equatable {
  final bool enabled;
  final bool orderUpdates;
  final bool messages;
  final bool promotions;
  final bool weeklySummary;
  final bool monthlyReport;

  const EmailNotificationSettings({
    required this.enabled,
    required this.orderUpdates,
    required this.messages,
    required this.promotions,
    required this.weeklySummary,
    required this.monthlyReport,
  });

  @override
  List<Object?> get props => [
        enabled,
        orderUpdates,
        messages,
        promotions,
        weeklySummary,
        monthlyReport,
      ];
}

class SmsNotificationSettings extends Equatable {
  final bool enabled;
  final bool orderUpdates;
  final bool paymentConfirmations;

  const SmsNotificationSettings({
    required this.enabled,
    required this.orderUpdates,
    required this.paymentConfirmations,
  });

  @override
  List<Object?> get props => [enabled, orderUpdates, paymentConfirmations];
}

class InAppNotificationSettings extends Equatable {
  final bool enabled;
  final bool sound;
  final bool vibration;
  final bool badge;

  const InAppNotificationSettings({
    required this.enabled,
    required this.sound,
    required this.vibration,
    required this.badge,
  });

  @override
  List<Object?> get props => [enabled, sound, vibration, badge];
}

class QuietHours extends Equatable {
  final bool enabled;
  final String startTime; // "22:00"
  final String endTime; // "07:00"
  final String timezone; // "Asia/Jakarta"

  const QuietHours({
    required this.enabled,
    required this.startTime,
    required this.endTime,
    required this.timezone,
  });

  @override
  List<Object?> get props => [enabled, startTime, endTime, timezone];
}

class MarkReadResult extends Equatable {
  final String notificationId;
  final bool isRead;
  final DateTime readAt;

  const MarkReadResult({
    required this.notificationId,
    required this.isRead,
    required this.readAt,
  });

  @override
  List<Object?> get props => [notificationId, isRead, readAt];
}

class MarkAllReadResult extends Equatable {
  final int markedCount;
  final DateTime markedAt;

  const MarkAllReadResult({
    required this.markedCount,
    required this.markedAt,
  });

  @override
  List<Object?> get props => [markedCount, markedAt];
}

class ClearNotificationsResult extends Equatable {
  final int deletedCount;

  const ClearNotificationsResult({required this.deletedCount});

  @override
  List<Object?> get props => [deletedCount];
}
