import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/message.dart';
import '../../repositories/messaging_repository.dart';

class SendMessage {
  final MessagingRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, Message>> call({
    required String conversationId,
    required String type,
    String? content,
    List<String>? imagePaths,
    String? productId,
    String? orderId,
    String? voicePath,
    String? replyToMessageId,
  }) async {
    return await repository.sendMessage(
      conversationId: conversationId,
      type: type,
      content: content,
      imagePaths: imagePaths,
      productId: productId,
      orderId: orderId,
      voicePath: voicePath,
      replyToMessageId: replyToMessageId,
    );
  }
}
