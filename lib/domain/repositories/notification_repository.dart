import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationList>> getNotifications({
    String type = 'all',
    String status = 'all',
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, MarkReadResult>> markAsRead(String notificationId);

  Future<Either<Failure, MarkAllReadResult>> markAllAsRead({String? type});

  Future<Either<Failure, void>> deleteNotification(String notificationId);

  Future<Either<Failure, ClearNotificationsResult>> clearNotifications({
    String? type,
    int? olderThanDays,
  });

  Future<Either<Failure, NotificationSettings>> getNotificationSettings();

  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    Map<String, dynamic> settings,
  );
}
