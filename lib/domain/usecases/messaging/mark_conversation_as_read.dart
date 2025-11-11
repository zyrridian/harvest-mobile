import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class MarkConversationAsRead {
  final MessagingRepository repository;

  MarkConversationAsRead(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String conversationId,
  }) async {
    return await repository.markConversationAsRead(
      conversationId: conversationId,
    );
  }
}
