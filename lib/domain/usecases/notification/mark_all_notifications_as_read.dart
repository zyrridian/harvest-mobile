import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class MarkAllNotificationsAsRead {
  final NotificationRepository repository;

  MarkAllNotificationsAsRead(this.repository);

  Future<Either<Failure, MarkAllReadResult>> call({String? type}) async {
    return await repository.markAllAsRead(type: type);
  }
}
