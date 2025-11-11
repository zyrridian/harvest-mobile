import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NotificationList>> getNotifications({
    String type = 'all',
    String status = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getNotifications(
        type: type,
        status: status,
        page: page,
        limit: limit,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MarkReadResult>> markAsRead(
    String notificationId,
  ) async {
    try {
      final result = await remoteDataSource.markAsRead(notificationId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MarkAllReadResult>> markAllAsRead({
    String? type,
  }) async {
    try {
      final result = await remoteDataSource.markAllAsRead(type: type);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClearNotificationsResult>> clearNotifications({
    String? type,
    int? olderThanDays,
  }) async {
    try {
      final result = await remoteDataSource.clearNotifications(
        type: type,
        olderThanDays: olderThanDays,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>>
      getNotificationSettings() async {
    try {
      final result = await remoteDataSource.getNotificationSettings();
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final result =
          await remoteDataSource.updateNotificationSettings(settings);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
