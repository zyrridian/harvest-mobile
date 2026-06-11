import '../../repositories/chat_socket_repository.dart';

/// Emits typing indicator events (start or stop) through the real-time socket.
///
/// This is distinct from [SendTypingIndicator] which uses the REST API.
/// For the socket-based chat screen, use this use case instead.
class SendSocketTypingIndicator {
  final ChatSocketRepository _repository;

  SendSocketTypingIndicator(this._repository);

  void start(String conversationId) => _repository.startTyping(conversationId);
  void stop(String conversationId) => _repository.stopTyping(conversationId);
}
