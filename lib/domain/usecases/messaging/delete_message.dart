import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class DeleteMessage {
  final MessagingRepository repository;

  DeleteMessage(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String messageId,
    String deleteFor = 'me',
  }) async {
    return await repository.deleteMessage(
      messageId: messageId,
      deleteFor: deleteFor,
    );
  }
}
