import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import '../../../../../core/constants/app_constants.dart';

/// Payload emitted from the backend on `message:new`
class SocketNewMessage {
  final String messageId;
  final String? tempId;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String type;
  final String? content;
  final DateTime timestamp;
  final bool isRead;
  final bool isEdited;

  const SocketNewMessage({
    required this.messageId,
    this.tempId,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    this.content,
    required this.timestamp,
    required this.isRead,
    required this.isEdited,
  });

  factory SocketNewMessage.fromJson(Map<String, dynamic> json) {
    return SocketNewMessage(
      messageId: json['message_id'] as String,
      tempId: json['temp_id'] as String?,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String? ?? '',
      senderAvatar: json['sender_avatar'] as String?,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
      isEdited: json['is_edited'] as bool? ?? false,
    );
  }
}

/// Low-level service wrapping socket_io_client.
///
/// Responsibilities:
///  - Managing the socket connection lifecycle (connect / disconnect).
///  - Emitting events to the backend.
///  - Broadcasting raw incoming events through [StreamController]s so that the
///    repository layer can map them to domain entities.
class ChatSocketService {
  io.Socket? _socket;

  // ── Incoming event streams ──────────────────────────────────────────────────

  final _newMessageController =
      StreamController<SocketNewMessage>.broadcast();
  final _readAckController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _typingStartController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _typingStopController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userOnlineController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userOfflineController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _conversationUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // Public stream accessors
  Stream<SocketNewMessage> get onNewMessage => _newMessageController.stream;
  Stream<Map<String, dynamic>> get onReadAck => _readAckController.stream;
  Stream<Map<String, dynamic>> get onTypingStart =>
      _typingStartController.stream;
  Stream<Map<String, dynamic>> get onTypingStop => _typingStopController.stream;
  Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;
  Stream<Map<String, dynamic>> get onUserOffline =>
      _userOfflineController.stream;
  Stream<Map<String, dynamic>> get onConversationUpdate =>
      _conversationUpdateController.stream;
  Stream<String> get onError => _errorController.stream;

  bool get isConnected => _socket?.connected ?? false;

  // ── Connection ─────────────────────────────────────────────────────────────

  /// Connects to the Socket.IO server using the provided [token].
  void connect(String token) {
    if (_socket?.connected ?? false) return;

    _socket = io.io(
      AppConstants.baseUrl,
      io.OptionBuilder()
          .setPath('/api/socket')
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(2000)
          .setReconnectionAttempts(10)
          .build(),
    );

    _socket!.monitor(id: 'chat_socket');
    _socket!.connect();
    _registerListeners();
  }

  /// Disconnects and cleans up the socket.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  // ── Emitters ───────────────────────────────────────────────────────────────



  /// Sends a new message via the socket.
  void emitSendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
    String? tempId,
  }) {
    _socket?.emitTracked('message:send', {
      'conversation_id': conversationId,
      'content': content,
      'type': type,
      if (tempId != null) 'temp_id': tempId,
    });
  }

  /// Marks all unread messages in a conversation as read.
  void emitMarkAsRead(String conversationId) {
    _socket?.emitTracked('message:read', {'conversation_id': conversationId});
  }

  /// Emits a typing-started event.
  void emitTypingStart(String conversationId) {
    _socket?.emitTracked('typing:start', {'conversation_id': conversationId});
  }

  /// Emits a typing-stopped event.
  void emitTypingStop(String conversationId) {
    _socket?.emitTracked('typing:stop', {'conversation_id': conversationId});
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  void _registerListeners() {
    final socket = _socket;
    if (socket == null) return;

    socket.on('message:new', (data) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        _newMessageController.add(SocketNewMessage.fromJson(map));
      } catch (_) {}
    });

    socket.on('message:read_ack', (data) {
      try {
        _readAckController.add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('typing:start', (data) {
      try {
        _typingStartController.add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('typing:stop', (data) {
      try {
        _typingStopController.add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('user:online', (data) {
      try {
        _userOnlineController.add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('user:offline', (data) {
      try {
        _userOfflineController.add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('conversation:update', (data) {
      try {
        _conversationUpdateController
            .add(Map<String, dynamic>.from(data as Map));
      } catch (_) {}
    });

    socket.on('error', (data) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        _errorController.add(map['message']?.toString() ?? 'Unknown error');
      } catch (_) {}
    });
  }

  /// Disposes all stream controllers. Call this when the service is destroyed.
  void dispose() {
    disconnect();
    _newMessageController.close();
    _readAckController.close();
    _typingStartController.close();
    _typingStopController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _conversationUpdateController.close();
    _errorController.close();
  }
}
