import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class UpdateNotificationSettings {
  final NotificationRepository repository;

  UpdateNotificationSettings(this.repository);

  Future<Either<Failure, NotificationSettings>> call(
    Map<String, dynamic> settings,
  ) async {
    return await repository.updateNotificationSettings(settings);
  }
}
