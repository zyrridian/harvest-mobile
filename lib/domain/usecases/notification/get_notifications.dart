import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<Either<Failure, NotificationList>> call({
    String type = 'all',
    String status = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getNotifications(
      type: type,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
