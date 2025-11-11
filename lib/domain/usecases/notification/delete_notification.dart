import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/notification_repository.dart';

class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  Future<Either<Failure, void>> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}
