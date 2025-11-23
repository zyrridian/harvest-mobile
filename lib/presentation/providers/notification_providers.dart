import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/notification/get_notifications.dart';
import '../../domain/usecases/notification/mark_notification_as_read.dart';
import '../../domain/usecases/notification/mark_all_notifications_as_read.dart';
import '../../domain/usecases/notification/delete_notification.dart';
import '../../domain/usecases/notification/clear_notifications.dart';
import '../../domain/usecases/notification/get_notification_settings.dart';
import '../../domain/usecases/notification/update_notification_settings.dart';

// Data Source Provider
final notificationDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl();
});

// Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dataSource = ref.watch(notificationDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: dataSource);
});

// Use Case Providers
final getNotificationsUseCaseProvider = Provider<GetNotifications>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotifications(repository);
});

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsRead>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkNotificationAsRead(repository);
});

final markAllNotificationsAsReadUseCaseProvider =
    Provider<MarkAllNotificationsAsRead>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllNotificationsAsRead(repository);
});

final deleteNotificationUseCaseProvider = Provider<DeleteNotification>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return DeleteNotification(repository);
});

final clearNotificationsUseCaseProvider = Provider<ClearNotifications>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return ClearNotifications(repository);
});

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettings>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationSettings(repository);
});

final updateNotificationSettingsUseCaseProvider =
    Provider<UpdateNotificationSettings>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return UpdateNotificationSettings(repository);
});

// Notifications List Provider
final notificationsProvider = FutureProvider.autoDispose
    .family<NotificationList, NotificationParams>((ref, params) async {
  final useCase = ref.watch(getNotificationsUseCaseProvider);
  final result = await useCase(
    type: params.type,
    status: params.status,
    page: params.page,
    limit: params.limit,
  );

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (notificationList) => notificationList,
  );
});

// Notification Settings Provider
final notificationSettingsProvider =
    FutureProvider.autoDispose<NotificationSettings>((ref) async {
  final useCase = ref.watch(getNotificationSettingsUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (settings) => settings,
  );
});

// Helper class for notification params
class NotificationParams {
  final String type;
  final String status;
  final int page;
  final int limit;

  NotificationParams({
    this.type = 'all',
    this.status = 'all',
    this.page = 1,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationParams &&
        other.type == type &&
        other.status == status &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return type.hashCode ^ status.hashCode ^ page.hashCode ^ limit.hashCode;
  }
}
