import '../../repositories/chat_socket_repository.dart';

/// Sends a text message through the real-time socket.
///
/// [tempId] is optional and useful for optimistic UI updates: the caller can
/// generate a UUID locally, add the message to the list immediately, and then
/// reconcile it with the server-confirmed message (which echoes [tempId] back
/// in the `message:new` event).
class SendSocketMessage {
  final ChatSocketRepository _repository;

  SendSocketMessage(this._repository);

  void call({
    required String conversationId,
    required String content,
    String type = 'text',
    String? tempId,
  }) =>
      _repository.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        tempId: tempId,
      );
}
