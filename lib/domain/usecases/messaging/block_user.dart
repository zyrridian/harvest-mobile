import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class BlockUser {
  final MessagingRepository repository;

  BlockUser(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String userId,
  }) async {
    return await repository.blockUser(
      userId: userId,
    );
  }
}
