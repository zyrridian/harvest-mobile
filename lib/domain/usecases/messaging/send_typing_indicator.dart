import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class SendTypingIndicator {
  final MessagingRepository repository;

  SendTypingIndicator(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String conversationId,
    required bool isTyping,
  }) async {
    return await repository.sendTypingIndicator(
      conversationId: conversationId,
      isTyping: isTyping,
    );
  }
}
