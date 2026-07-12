import '../repositories/chat_socket_repository.dart';
import '../entities/message.dart';

/// Connects the socket and returns the stream of incoming [Message] entities.
///
/// This is the primary use case for the chat screen.  Call [connect] once when
/// entering the chat, then listen to [call] to receive real-time messages.
class ConnectChatSocket {
  final ChatSocketRepository _repository;

  ConnectChatSocket(this._repository);

  Future<void> connect() => _repository.connect();

  Stream<Message> call() => _repository.onNewMessage;
}
