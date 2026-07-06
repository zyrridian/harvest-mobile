import '../entities/message.dart';

/// Abstract domain contract for the real-time chat socket layer.
///
/// The presentation layer should depend on this interface, not on any concrete
/// implementation. All actions are fire-and-forget (void); incoming data is
/// surfaced through typed Dart [Stream]s so the UI can reactively rebuild.
abstract class ChatSocketRepository {
  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Establishes the socket connection.  
  /// The implementation is responsible for retrieving the auth token.
  Future<void> connect();

  /// Tears down the socket connection.
  void disconnect();

  // ── Actions (Frontend → Backend) ──────────────────────────────────────────



  /// Emits a new text message to the backend.
  ///
  /// [tempId] can be used to correlate the optimistic-UI entry with the
  /// server-confirmed message returned in the [onNewMessage] stream.
  void sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
    String? tempId,
  });

  /// Marks all unread messages in [conversationId] as read.
  void markAsRead(String conversationId);

  /// Tells the backend the current user started typing.
  void startTyping(String conversationId);

  /// Tells the backend the current user stopped typing.
  void stopTyping(String conversationId);

  // ── Incoming streams (Backend → Frontend) ─────────────────────────────────

  /// Emits a domain [Message] every time a new message arrives in any joined
  /// conversation.
  Stream<Message> get onNewMessage;

  /// Emits a map containing `conversation_id` and `reader_id` when the other
  /// participant has read your messages.
  Stream<Map<String, dynamic>> get onMessageReadAck;

  /// Emits a map with `conversation_id` and `user_id` when the other user
  /// starts typing.
  Stream<Map<String, dynamic>> get onTypingStart;

  /// Emits a map with `conversation_id` and `user_id` when the other user
  /// stops typing.
  Stream<Map<String, dynamic>> get onTypingStop;

  /// Emits a map with `userId` when a contact comes online.
  Stream<Map<String, dynamic>> get onUserOnline;

  /// Emits a map with `userId` and `last_seen` when a contact goes offline.
  Stream<Map<String, dynamic>> get onUserOffline;

  /// Emits a map with `conversation_id` and `last_message` to keep the
  /// conversation list up to date.
  Stream<Map<String, dynamic>> get onConversationUpdate;

  /// Emits an error description string when something goes wrong on the server.
  Stream<String> get onError;

  /// Whether the socket is currently connected.
  bool get isConnected;
}
