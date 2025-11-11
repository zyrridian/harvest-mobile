import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<Either<Failure, MarkReadResult>> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}
