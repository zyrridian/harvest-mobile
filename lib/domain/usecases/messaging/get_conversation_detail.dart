import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/conversation.dart';
import '../../repositories/messaging_repository.dart';

class GetConversationDetail {
  final MessagingRepository repository;

  GetConversationDetail(this.repository);

  Future<Either<Failure, ConversationDetail>> call({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    return await repository.getConversationDetail(
      conversationId: conversationId,
      page: page,
      limit: limit,
      beforeMessageId: beforeMessageId,
    );
  }
}
