import '../../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationListModel> getNotifications({
    String type = 'all',
    String status = 'all',
    int page = 1,
    int limit = 20,
  });

  Future<MarkReadResultModel> markAsRead(String notificationId);

  Future<MarkAllReadResultModel> markAllAsRead({String? type});

  Future<void> deleteNotification(String notificationId);

  Future<ClearNotificationsResultModel> clearNotifications({
    String? type,
    int? olderThanDays,
  });

  Future<NotificationSettingsModel> getNotificationSettings();

  Future<NotificationSettingsModel> updateNotificationSettings(
    Map<String, dynamic> settings,
  );
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<NotificationListModel> getNotifications({
    String type = 'all',
    String status = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "notifications": [
          {
            "notification_id": "notif_1234567890",
            "type": "order",
            "title": "Order Shipped",
            "message":
                "Your order FM20251009001 has been shipped and is on the way!",
            "icon": "📦",
            "image": "https://cdn.farmmarket.com/products/prd_123.jpg",
            "reference": {"type": "order", "id": "ord_1234567890abcdef"},
            "action": {
              "type": "navigate",
              "screen": "order_detail",
              "params": {"order_id": "ord_1234567890abcdef"}
            },
            "is_read": false,
            "priority": "high",
            "created_at": "2025-10-10T10:00:00Z"
          },
          {
            "notification_id": "notif_9876543210",
            "type": "message",
            "title": "New Message",
            "message": "Green Valley Farm: Thank you for your order!",
            "icon": "💬",
            "image": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
            "reference": {
              "type": "conversation",
              "id": "conv_1234567890abcdef"
            },
            "action": {
              "type": "navigate",
              "screen": "chat",
              "params": {"conversation_id": "conv_1234567890abcdef"}
            },
            "is_read": false,
            "priority": "medium",
            "created_at": "2025-10-09T15:30:00Z"
          },
          {
            "notification_id": "notif_price_alert",
            "type": "price_alert",
            "title": "Price Drop Alert",
            "message": "Organic Tomatoes is now Rp 13,500 (10% off)!",
            "icon": "🏷️",
            "image": "https://cdn.farmmarket.com/products/prd_123.jpg",
            "reference": {"type": "product", "id": "prd_123"},
            "action": {
              "type": "navigate",
              "screen": "product_detail",
              "params": {"product_id": "prd_123"}
            },
            "is_read": true,
            "read_at": "2025-10-09T14:00:00Z",
            "priority": "medium",
            "created_at": "2025-10-09T12:00:00Z"
          },
          {
            "notification_id": "notif_stock_alert",
            "type": "stock_alert",
            "title": "Back in Stock!",
            "message":
                "Fresh Strawberries that you favorited is now available!",
            "icon": "🔔",
            "image": "https://cdn.farmmarket.com/products/prd_789.jpg",
            "reference": {"type": "product", "id": "prd_789"},
            "action": {
              "type": "navigate",
              "screen": "product_detail",
              "params": {"product_id": "prd_789"}
            },
            "is_read": false,
            "priority": "medium",
            "created_at": "2025-10-08T14:00:00Z"
          }
        ],
        "stats": {
          "total_unread": 4,
          "by_type": {
            "order": 2,
            "message": 1,
            "promotion": 0,
            "price_alert": 0,
            "stock_alert": 1,
            "system": 0
          }
        },
        "pagination": {
          "current_page": 1,
          "total_pages": 3,
          "total_items": 45,
          "items_per_page": 20,
          "has_next": true,
          "has_previous": false
        }
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return NotificationListModel.fromJson(data);
  }

  @override
  Future<MarkReadResultModel> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Notification marked as read",
      "data": {
        "notification_id": notificationId,
        "is_read": true,
        "read_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return MarkReadResultModel.fromJson(data);
  }

  @override
  Future<MarkAllReadResultModel> markAllAsRead({String? type}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "All notifications marked as read",
      "data": {
        "marked_count": 15,
        "marked_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return MarkAllReadResultModel.fromJson(data);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Success - no return value needed
  }

  @override
  Future<ClearNotificationsResultModel> clearNotifications({
    String? type,
    int? olderThanDays,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Notifications cleared",
      "data": {"deleted_count": 20}
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return ClearNotificationsResultModel.fromJson(data);
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "push_notifications": {
          "enabled": true,
          "order_updates": true,
          "messages": true,
          "promotions": false,
          "price_alerts": true,
          "stock_alerts": true,
          "system_updates": true,
          "new_followers": true,
          "reviews": true
        },
        "email_notifications": {
          "enabled": true,
          "order_updates": true,
          "messages": false,
          "promotions": true,
          "weekly_summary": true,
          "monthly_report": true
        },
        "sms_notifications": {
          "enabled": false,
          "order_updates": false,
          "payment_confirmations": false
        },
        "in_app_notifications": {
          "enabled": true,
          "sound": true,
          "vibration": true,
          "badge": true
        },
        "quiet_hours": {
          "enabled": true,
          "start_time": "22:00",
          "end_time": "07:00",
          "timezone": "Asia/Jakarta"
        }
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return NotificationSettingsModel.fromJson(data);
  }

  @override
  Future<NotificationSettingsModel> updateNotificationSettings(
    Map<String, dynamic> settings,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Return the updated settings (in real API, this would be merged with existing settings)
    final mockResponse = await getNotificationSettings();
    return mockResponse;
  }
}
