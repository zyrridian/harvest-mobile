import '../../repositories/chat_socket_repository.dart';

/// Marks all unread messages in the given conversation as read via the socket.
class MarkConversationRead {
  final ChatSocketRepository _repository;

  MarkConversationRead(this._repository);

  void call(String conversationId) => _repository.markAsRead(conversationId);
}
