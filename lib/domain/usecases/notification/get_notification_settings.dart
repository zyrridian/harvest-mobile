import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationSettings {
  final NotificationRepository repository;

  GetNotificationSettings(this.repository);

  Future<Either<Failure, NotificationSettings>> call() async {
    return await repository.getNotificationSettings();
  }
}
