import '../../repositories/chat_socket_repository.dart';

/// Joins the socket room for the given conversation, making the connection
/// ready to receive and send messages.
class JoinConversation {
  final ChatSocketRepository _repository;

  JoinConversation(this._repository);

  void call(String conversationId) =>
      _repository.joinConversation(conversationId);
}
