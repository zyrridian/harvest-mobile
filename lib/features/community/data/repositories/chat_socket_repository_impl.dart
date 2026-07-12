import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_socket_repository.dart';
import '../datasources/remote/chat_socket_service.dart';

/// Concrete implementation of [ChatSocketRepository].
///
/// Bridges the low-level [ChatSocketService] with the domain layer by:
///  - Fetching the auth token from secure storage before connecting.
///  - Mapping [SocketNewMessage] payloads into [Message] domain entities.
///  - Delegating all emit/stream operations to the service.
class ChatSocketRepositoryImpl implements ChatSocketRepository {
  final ChatSocketService _socketService;
  final FlutterSecureStorage _secureStorage;

  ChatSocketRepositoryImpl(this._socketService, this._secureStorage);

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  Future<void> connect() async {
    final token = await _secureStorage.read(key: AppConstants.authTokenKey);
    if (token == null || token.isEmpty) {
      // No token available – skip connection; user is not authenticated.
      return;
    }
    _socketService.connect(token);
  }

  @override
  void disconnect() => _socketService.disconnect();

  // ── Actions ────────────────────────────────────────────────────────────────



  @override
  void sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
    String? tempId,
  }) =>
      _socketService.emitSendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        tempId: tempId,
      );

  @override
  void markAsRead(String conversationId) =>
      _socketService.emitMarkAsRead(conversationId);

  @override
  void startTyping(String conversationId) =>
      _socketService.emitTypingStart(conversationId);

  @override
  void stopTyping(String conversationId) =>
      _socketService.emitTypingStop(conversationId);

  // ── Incoming streams ───────────────────────────────────────────────────────

  @override
  Stream<Message> get onNewMessage => _socketService.onNewMessage.map(
        (socketMsg) => Message(
          messageId: socketMsg.messageId,
          sender: MessageUser(
            userId: socketMsg.senderId,
            name: socketMsg.senderName,
            profilePicture: socketMsg.senderAvatar,
          ),
          type: socketMsg.type,
          content: socketMsg.content,
          timestamp: socketMsg.timestamp,
          isRead: socketMsg.isRead,
          isEdited: socketMsg.isEdited,
        ),
      );

  @override
  Stream<Map<String, dynamic>> get onMessageReadAck =>
      _socketService.onReadAck;

  @override
  Stream<Map<String, dynamic>> get onTypingStart =>
      _socketService.onTypingStart;

  @override
  Stream<Map<String, dynamic>> get onTypingStop => _socketService.onTypingStop;

  @override
  Stream<Map<String, dynamic>> get onUserOnline => _socketService.onUserOnline;

  @override
  Stream<Map<String, dynamic>> get onUserOffline =>
      _socketService.onUserOffline;

  @override
  Stream<Map<String, dynamic>> get onConversationUpdate =>
      _socketService.onConversationUpdate;

  @override
  Stream<String> get onError => _socketService.onError;

  @override
  bool get isConnected => _socketService.isConnected;
}
