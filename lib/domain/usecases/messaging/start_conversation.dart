import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class StartConversation {
  final MessagingRepository repository;

  StartConversation(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  }) async {
    return await repository.startConversation(
      recipientId: recipientId,
      type: type,
      orderId: orderId,
      productId: productId,
      initialMessage: initialMessage,
    );
  }
}
