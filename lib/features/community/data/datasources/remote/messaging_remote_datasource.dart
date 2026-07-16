import 'package:dio/dio.dart';
import '../../models/conversation_model.dart';
import '../../../../chat/data/models/message_model.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../../../core/constants/app_constants.dart';

abstract class MessagingRemoteDataSource {
  Future<Map<String, dynamic>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  });

  Future<ConversationDetail> getConversationDetail({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  });

  Future<Map<String, dynamic>> startConversation({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  });

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String type,
    String? content,
    List<String>? imagePaths,
    String? productId,
    String? orderId,
    String? voicePath,
    String? replyToMessageId,
  });

  Future<Map<String, dynamic>> editMessage({
    required String messageId,
    required String content,
  });

  Future<Map<String, dynamic>> deleteMessage({
    required String messageId,
    String deleteFor = 'me',
  });

  Future<Map<String, dynamic>> markMessageAsRead({
    required String messageId,
  });

  Future<Map<String, dynamic>> markConversationAsRead({
    required String conversationId,
  });

  Future<Map<String, dynamic>> addReaction({
    required String messageId,
    required String emoji,
  });

  Future<Map<String, dynamic>> removeReaction({
    required String messageId,
  });

  Future<Map<String, dynamic>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  });

  Future<Map<String, dynamic>> muteConversation({
    required String conversationId,
    int? duration,
  });

  Future<Map<String, dynamic>> unmuteConversation({
    required String conversationId,
  });

  Future<Map<String, dynamic>> pinConversation({
    required String conversationId,
  });

  Future<Map<String, dynamic>> unpinConversation({
    required String conversationId,
  });

  Future<Map<String, dynamic>> deleteConversation({
    required String conversationId,
  });

  Future<Map<String, dynamic>> blockUser({
    required String userId,
  });

  Future<Map<String, dynamic>> unblockUser({
    required String userId,
  });

  Future<List<BlockedUserModel>> getBlockedUsers();
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers – manual JSON parsing matching the actual backend shapes
// ─────────────────────────────────────────────────────────────────────────────

/// Parses the participant object from the DETAIL endpoint (fewer required fields)
ConversationParticipant _parseParticipant(Map<String, dynamic> p) {
  return ConversationParticipant(
    userId: p['user_id'] as String,
    name: p['name'] as String? ?? '',
    profilePicture: p['profile_picture'] as String?,
    userType: p['user_type'] as String? ?? 'producer',
    isOnline: p['is_online'] as bool? ?? false,
    lastSeen: p['last_seen'] != null
        ? DateTime.tryParse(p['last_seen'] as String)
        : null,
    verified: p['verified'] as bool? ?? false,
    responseRate: (p['response_rate'] as num?)?.toInt(),
    responseTime: p['response_time'] as String?,
  );
}

/// Parses a single message from the DETAIL endpoint.
/// The backend returns flat sender_id / sender_name instead of a nested object.
Message _parseMessage(Map<String, dynamic> m) {
  return Message(
    messageId: m['message_id'] as String,
    sender: MessageUser(
      userId: m['sender_id'] as String? ?? '',
      name: m['sender_name'] as String? ?? '',
      profilePicture: m['sender_avatar'] as String?,
    ),
    type: m['type'] as String? ?? 'text',
    content: m['content'] as String?,
    timestamp: m['timestamp'] != null
        ? DateTime.tryParse(m['timestamp'] as String) ?? DateTime.now()
        : DateTime.now(),
    isRead: m['is_read'] as bool? ?? false,
    readAt:
        m['read_at'] != null ? DateTime.tryParse(m['read_at'] as String) : null,
    isEdited: m['is_edited'] as bool? ?? false,
    isDeleted: m['is_deleted'] as bool? ?? false,
    text: m['text'] as String?,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Real implementation
// ─────────────────────────────────────────────────────────────────────────────

class MessagingRemoteDataSourceImpl implements MessagingRemoteDataSource {
  final Dio _dio;

  MessagingRemoteDataSourceImpl(this._dio);

  // ── Conversations ─────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      AppConstants.conversationsEndpoint,
      queryParameters: {
        if (filter != 'all') 'filter': filter,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );
    return response.data ?? {};
  }

  @override
  Future<ConversationDetail> getConversationDetail({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (beforeMessageId != null) 'before_message_id': beforeMessageId,
      },
    );

    final body = response.data ?? {};
    final data = body['data'] as Map<String, dynamic>? ?? body;

    final participant =
        _parseParticipant(data['participant'] as Map<String, dynamic>);

    final rawMessages = data['messages'] as List<dynamic>? ?? [];
    final messages = rawMessages
        .map((m) => _parseMessage(m as Map<String, dynamic>))
        .toList();

    ConversationOrder? order;
    final rawOrder = data['order'];
    if (rawOrder != null) {
      final o = rawOrder as Map<String, dynamic>;
      order = ConversationOrder(
        orderId: o['order_id'] as String,
        orderNumber: o['order_number'] as String,
        status: o['status'] as String,
        totalAmount: (o['total_amount'] as num?)?.toInt(),
        itemsCount: (o['items_count'] as num?)?.toInt(),
      );
    }

    return ConversationDetail(
      conversationId: data['conversation_id'] as String,
      type: data['type'] as String? ?? 'general',
      participant: participant,
      order: order,
      messages: messages,
      quickReplies: const [],
      typingIndicator: const TypingIndicator(isTyping: false),
      canSendMessages: true,
      blocked: false,
      muted: false,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  Future<Map<String, dynamic>> startConversation({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.conversationsEndpoint,
      data: {
        'recipient_id': recipientId,
        'type': type,
        if (orderId != null) 'order_id': orderId,
        if (productId != null) 'product_id': productId,
        if (initialMessage != null && initialMessage.isNotEmpty)
          'initial_message': initialMessage,
      },
    );
    return response.data ?? {};
  }

  // ── Messages ──────────────────────────────────────────────────────────────

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String type,
    String? content,
    List<String>? imagePaths,
    String? productId,
    String? orderId,
    String? voicePath,
    String? replyToMessageId,
  }) async {
    final hasFiles = (imagePaths != null && imagePaths.isNotEmpty) || voicePath != null;

    Response<Map<String, dynamic>> response;

    if (hasFiles) {
      final formData = FormData.fromMap({
        'type': type,
        if (content != null) 'content': content,
        if (productId != null) 'product_id': productId,
        if (orderId != null) 'order_id': orderId,
        if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      });

      if (imagePaths != null) {
        for (final path in imagePaths) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(path),
          ));
        }
      }
      if (voicePath != null) {
        formData.files.add(MapEntry(
          'voice',
          await MultipartFile.fromFile(voicePath),
        ));
      }

      response = await _dio.post<Map<String, dynamic>>(
        '${AppConstants.conversationsEndpoint}/$conversationId/messages',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } else {
      response = await _dio.post<Map<String, dynamic>>(
        '${AppConstants.conversationsEndpoint}/$conversationId/messages',
        data: {
          'type': type,
          if (content != null) 'content': content,
          if (productId != null) 'product_id': productId,
          if (orderId != null) 'order_id': orderId,
          if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
        },
      );
    }

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        {};

    // Build a MessageModel from the flat response
    return MessageModel.fromJson({
      'message_id': data['message_id'] ?? '',
      'sender': {
        'user_id': data['sender_id'] ?? '',
        'name': data['sender_name'] ?? 'You',
        'profile_picture': data['sender_avatar'],
      },
      'type': data['type'] ?? type,
      'content': data['content'] ?? content,
      'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
      'is_read': data['is_read'] ?? false,
      'is_edited': data['is_edited'] ?? false,
      'is_deleted': data['is_deleted'] ?? false,
    });
  }

  @override
  Future<Map<String, dynamic>> editMessage({
    required String messageId,
    required String content,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${AppConstants.messagesEndpoint}/$messageId',
      data: {'content': content},
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> deleteMessage({
    required String messageId,
    String deleteFor = 'me',
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.messagesEndpoint}/$messageId',
      queryParameters: {'delete_for': deleteFor},
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> markMessageAsRead({
    required String messageId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.messagesEndpoint}/$messageId/read',
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> markConversationAsRead({
    required String conversationId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId/read-all',
    );
    return response.data ?? {};
  }

  // ── Reactions ─────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.messagesEndpoint}/$messageId/reaction',
      data: {'emoji': emoji},
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> removeReaction({
    required String messageId,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.messagesEndpoint}/$messageId/reaction',
    );
    return response.data ?? {};
  }

  // ── Typing (REST fallback – real-time via socket) ─────────────────────────

  @override
  Future<Map<String, dynamic>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    // Typing is handled in real-time by the socket; this REST method is a
    // no-op placeholder kept for interface compatibility.
    return {'status': 'ok'};
  }

  // ── Mute / Pin ────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> muteConversation({
    required String conversationId,
    int? duration,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId/mute',
      data: duration != null ? {'duration': duration} : null,
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> unmuteConversation({
    required String conversationId,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId/mute',
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> pinConversation({
    required String conversationId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId/pin',
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> unpinConversation({
    required String conversationId,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId/pin',
    );
    return response.data ?? {};
  }

  // ── Conversation management ───────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> deleteConversation({
    required String conversationId,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.conversationsEndpoint}/$conversationId',
    );
    return response.data ?? {};
  }

  // ── Block / Unblock ───────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> blockUser({
    required String userId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${AppConstants.usersEndpoint}/$userId/block',
    );
    return response.data ?? {};
  }

  @override
  Future<Map<String, dynamic>> unblockUser({
    required String userId,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${AppConstants.usersEndpoint}/$userId/block',
    );
    return response.data ?? {};
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers() async {
    final response = await _dio
        .get<Map<String, dynamic>>('${AppConstants.usersEndpoint}/blocked');
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => BlockedUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
