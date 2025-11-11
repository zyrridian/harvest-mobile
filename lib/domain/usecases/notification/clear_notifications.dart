import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class ClearNotifications {
  final NotificationRepository repository;

  ClearNotifications(this.repository);

  Future<Either<Failure, ClearNotificationsResult>> call({
    String? type,
    int? olderThanDays,
  }) async {
    return await repository.clearNotifications(
      type: type,
      olderThanDays: olderThanDays,
    );
  }
}
