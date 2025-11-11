import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

abstract class MessagingRemoteDataSource {
  Future<Map<String, dynamic>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  });

  Future<ConversationDetailModel> getConversationDetail({
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

class MessagingRemoteDataSourceImpl implements MessagingRemoteDataSource {
  // final ApiService apiService;
  // MessagingRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock JSON response matching API spec
    final mockResponse = {
      "status": "success",
      "data": {
        "conversations": [
          {
            "conversation_id": "conv_1234567890abcdef",
            "type": "order",
            "participant": {
              "user_id": "usr_987",
              "name": "Green Valley Farm",
              "profile_picture":
                  "https://cdn.farmmarket.com/profiles/usr_987.jpg",
              "user_type": "producer",
              "is_online": true,
              "last_seen": DateTime.now()
                  .subtract(const Duration(minutes: 5))
                  .toIso8601String(),
              "verified": true,
              "response_rate": 98,
              "response_time": "< 30 minutes"
            },
            "order": {
              "order_id": "ord_123",
              "order_number": "FM20251009001",
              "status": "shipped",
              "total_amount": 75050,
              "items_count": 2
            },
            "product": {
              "product_id": "prd_456",
              "name": "Organic Tomatoes",
              "image": "https://cdn.farmmarket.com/products/prd_456.jpg",
              "price": 15000
            },
            "last_message": {
              "message_id": "msg_789",
              "sender_id": "usr_987",
              "sender_name": "Green Valley Farm",
              "type": "text",
              "content": "Your order has been shipped!",
              "preview": "Your order has been shipped!",
              "timestamp": DateTime.now()
                  .subtract(const Duration(hours: 1))
                  .toIso8601String(),
              "is_read": false
            },
            "unread_count": 2,
            "muted": false,
            "pinned": false,
            "created_at": DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
            "updated_at": DateTime.now()
                .subtract(const Duration(hours: 1))
                .toIso8601String()
          },
          {
            "conversation_id": "conv_9876543210fedcba",
            "type": "general",
            "participant": {
              "user_id": "usr_654",
              "name": "Fresh Harvest Farm",
              "profile_picture":
                  "https://cdn.farmmarket.com/profiles/usr_654.jpg",
              "user_type": "producer",
              "is_online": false,
              "last_seen": DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
              "verified": true
            },
            "product": {
              "product_id": "prd_789",
              "name": "Fresh Strawberries",
              "image": "https://cdn.farmmarket.com/products/prd_789.jpg",
              "price": 45000
            },
            "last_message": {
              "message_id": "msg_456",
              "sender_id": "usr_123",
              "sender_name": "You",
              "type": "text",
              "content": "Is this still available?",
              "preview": "Is this still available?",
              "timestamp": DateTime.now()
                  .subtract(const Duration(hours: 3))
                  .toIso8601String(),
              "is_read": true
            },
            "unread_count": 0,
            "muted": false,
            "pinned": false,
            "created_at": DateTime.now()
                .subtract(const Duration(hours: 3))
                .toIso8601String(),
            "updated_at": DateTime.now()
                .subtract(const Duration(hours: 3))
                .toIso8601String()
          },
          {
            "conversation_id": "conv_abc123def456",
            "type": "general",
            "participant": {
              "user_id": "usr_321",
              "name": "Organic Gardens",
              "profile_picture":
                  "https://cdn.farmmarket.com/profiles/usr_321.jpg",
              "user_type": "producer",
              "is_online": true,
              "last_seen": DateTime.now().toIso8601String(),
              "verified": true,
              "response_rate": 95,
              "response_time": "< 1 hour"
            },
            "product": {
              "product_id": "prd_111",
              "name": "Fresh Lettuce",
              "image": "https://cdn.farmmarket.com/products/prd_111.jpg",
              "price": 8000
            },
            "last_message": {
              "message_id": "msg_111",
              "sender_id": "usr_321",
              "sender_name": "Organic Gardens",
              "type": "text",
              "content": "Yes, we have fresh stock today!",
              "preview": "Yes, we have fresh stock today!",
              "timestamp": DateTime.now()
                  .subtract(const Duration(minutes: 30))
                  .toIso8601String(),
              "is_read": true
            },
            "unread_count": 0,
            "muted": false,
            "pinned": true,
            "created_at": DateTime.now()
                .subtract(const Duration(days: 2))
                .toIso8601String(),
            "updated_at": DateTime.now()
                .subtract(const Duration(minutes: 30))
                .toIso8601String()
          }
        ],
        "stats": {
          "total_conversations": 15,
          "unread_conversations": 3,
          "total_unread_messages": 8
        },
        "pagination": {
          "current_page": 1,
          "total_pages": 1,
          "total_items": 15,
          "items_per_page": 20,
          "has_next": false,
          "has_previous": false
        }
      }
    };

    return mockResponse;

    // Real implementation:
    // return await apiService.get('/conversations', queryParams: {
    //   'filter': filter,
    //   if (search != null) 'search': search,
    //   'page': page.toString(),
    //   'limit': limit.toString(),
    // });
  }

  @override
  Future<ConversationDetailModel> getConversationDetail({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock JSON response matching API spec
    final mockResponse = {
      "conversation_id": conversationId,
      "type": "order",
      "participant": {
        "user_id": "usr_987",
        "name": "Green Valley Farm",
        "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
        "user_type": "producer",
        "is_online": true,
        "last_seen": DateTime.now().toIso8601String(),
        "verified": true,
        "response_rate": 98,
        "response_time": "< 30 minutes"
      },
      "order": {
        "order_id": "ord_123",
        "order_number": "FM20251009001",
        "status": "shipped",
        "total_amount": 75050,
        "items_count": 2
      },
      "messages": [
        {
          "message_id": "msg_001",
          "sender": {
            "user_id": "usr_123",
            "name": "Ahmad Zulfikar",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_123.jpg"
          },
          "type": "text",
          "content": "Hello, I'd like to order tomatoes",
          "timestamp": DateTime.now()
              .subtract(const Duration(days: 1, hours: 2))
              .toIso8601String(),
          "is_read": true,
          "read_at": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 58))
              .toIso8601String(),
          "is_edited": false,
          "is_deleted": false
        },
        {
          "message_id": "msg_002",
          "sender": {
            "user_id": "usr_987",
            "name": "Green Valley Farm",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
          },
          "type": "text",
          "content":
              "Hi! Sure, we have fresh organic tomatoes available. How many kg do you need?",
          "timestamp": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 55))
              .toIso8601String(),
          "is_read": true,
          "read_at": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 54))
              .toIso8601String(),
          "is_edited": false,
          "is_deleted": false
        },
        {
          "message_id": "msg_003",
          "sender": {
            "user_id": "usr_123",
            "name": "Ahmad Zulfikar",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_123.jpg"
          },
          "type": "product",
          "product": {
            "product_id": "prd_123",
            "name": "Organic Fresh Tomatoes",
            "image": "https://cdn.farmmarket.com/products/prd_123.jpg",
            "price": 15000,
            "unit": "kg",
            "availability": "in_stock"
          },
          "text": "I'd like 3 kg of this",
          "timestamp": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 53))
              .toIso8601String(),
          "is_read": true,
          "read_at": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 52))
              .toIso8601String(),
          "is_edited": false,
          "is_deleted": false
        },
        {
          "message_id": "msg_004",
          "sender": {
            "user_id": "usr_987",
            "name": "Green Valley Farm",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
          },
          "type": "text",
          "content": "Perfect! You can add it to cart and checkout.",
          "timestamp": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 50))
              .toIso8601String(),
          "is_read": true,
          "read_at": DateTime.now()
              .subtract(const Duration(days: 1, hours: 1, minutes: 48))
              .toIso8601String(),
          "is_edited": false,
          "is_deleted": false,
          "reactions": [
            {
              "emoji": "👍",
              "user_id": "usr_123",
              "timestamp": DateTime.now()
                  .subtract(const Duration(days: 1, hours: 1, minutes: 47))
                  .toIso8601String()
            }
          ]
        },
        {
          "message_id": "msg_005",
          "sender": {
            "user_id": "usr_987",
            "name": "Green Valley Farm",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
          },
          "type": "order",
          "order": {
            "order_id": "ord_123",
            "order_number": "FM20251009001",
            "status": "shipped",
            "total_amount": 75050,
            "items_count": 2,
            "created_at": DateTime.now()
                .subtract(const Duration(hours: 5))
                .toIso8601String()
          },
          "text": "Your order has been shipped! 🚚",
          "timestamp": DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
          "is_read": false,
          "is_edited": false,
          "is_deleted": false
        },
        {
          "message_id": "msg_006",
          "sender": {
            "user_id": "usr_987",
            "name": "Green Valley Farm",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
          },
          "type": "image",
          "images": [
            {
              "image_id": "img_msg_001",
              "url": "https://cdn.farmmarket.com/messages/img_msg_001.jpg",
              "thumbnail_url":
                  "https://cdn.farmmarket.com/messages/thumb_img_msg_001.jpg",
              "width": 1920,
              "height": 1080
            }
          ],
          "text": "Here's your packed order 📦",
          "timestamp": DateTime.now()
              .subtract(const Duration(minutes: 30))
              .toIso8601String(),
          "is_read": false,
          "is_edited": false,
          "is_deleted": false
        },
        {
          "message_id": "msg_007",
          "sender": {
            "user_id": "usr_123",
            "name": "Ahmad Zulfikar",
            "profile_picture": "https://cdn.farmmarket.com/profiles/usr_123.jpg"
          },
          "type": "voice",
          "voice": {
            "url": "https://cdn.farmmarket.com/messages/voice_007.m4a",
            "duration": 8,
            "waveform": [0.2, 0.5, 0.8, 0.6, 0.4, 0.7, 0.5, 0.3]
          },
          "timestamp": DateTime.now()
              .subtract(const Duration(minutes: 25))
              .toIso8601String(),
          "is_read": false,
          "is_played": false,
          "is_edited": false,
          "is_deleted": false
        }
      ],
      "quick_replies": [
        "Is this still available?",
        "What's the minimum order?",
        "Can you deliver today?",
        "Do you have organic certification?"
      ],
      "typing_indicator": {"is_typing": false, "user_id": null},
      "can_send_messages": true,
      "blocked": false,
      "muted": false,
      "created_at":
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
    };

    return ConversationDetailModel.fromJson(mockResponse);

    // Real implementation:
    // final response = await apiService.get('/conversations/$conversationId', queryParams: {
    //   'page': page.toString(),
    //   'limit': limit.toString(),
    //   if (beforeMessageId != null) 'before_message_id': beforeMessageId,
    // });
    // return ConversationDetailModel.fromJson(response['data']);
  }

  @override
  Future<Map<String, dynamic>> startConversation({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockResponse = {
      "status": "success",
      "message": "Conversation started",
      "data": {
        "conversation_id": "conv_new_${DateTime.now().millisecondsSinceEpoch}",
        "participant": {
          "user_id": recipientId,
          "name": "Green Valley Farm",
          "profile_picture":
              "https://cdn.farmmarket.com/profiles/$recipientId.jpg"
        },
        "message": {
          "message_id": "msg_${DateTime.now().millisecondsSinceEpoch}",
          "content": initialMessage ?? "",
          "timestamp": DateTime.now().toIso8601String()
        },
        "created_at": DateTime.now().toIso8601String()
      }
    };

    return mockResponse;

    // Real implementation:
    // return await apiService.post('/conversations', body: {
    //   'recipient_id': recipientId,
    //   'type': type,
    //   if (orderId != null) 'order_id': orderId,
    //   if (productId != null) 'product_id': productId,
    //   if (initialMessage != null) 'initial_message': initialMessage,
    // });
  }

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
    await Future.delayed(const Duration(milliseconds: 200));

    final mockResponse = {
      "message_id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "sender": {
        "user_id": "usr_123",
        "name": "You",
        "profile_picture": "https://cdn.farmmarket.com/profiles/usr_123.jpg"
      },
      "type": type,
      "content": content,
      "timestamp": DateTime.now().toIso8601String(),
      "is_read": false,
      "is_edited": false,
      "is_deleted": false
    };

    return MessageModel.fromJson(mockResponse);

    // Real implementation:
    // final formData = FormData();
    // formData.fields.add(MapEntry('type', type));
    // if (content != null) formData.fields.add(MapEntry('content', content));
    // if (imagePaths != null) {
    //   for (var path in imagePaths) {
    //     formData.files.add(MapEntry('images', await MultipartFile.fromFile(path)));
    //   }
    // }
    // if (productId != null) formData.fields.add(MapEntry('product_id', productId));
    // if (orderId != null) formData.fields.add(MapEntry('order_id', orderId));
    // if (voicePath != null) formData.files.add(MapEntry('voice', await MultipartFile.fromFile(voicePath)));
    // if (replyToMessageId != null) formData.fields.add(MapEntry('reply_to_message_id', replyToMessageId));
    //
    // final response = await apiService.post('/conversations/$conversationId/messages', formData: formData);
    // return MessageModel.fromJson(response['data']);
  }

  @override
  Future<Map<String, dynamic>> editMessage({
    required String messageId,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "status": "success",
      "message": "Message updated",
      "data": {
        "message_id": messageId,
        "content": content,
        "is_edited": true,
        "edited_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.put('/messages/$messageId', body: {'content': content});
  }

  @override
  Future<Map<String, dynamic>> deleteMessage({
    required String messageId,
    String deleteFor = 'me',
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "status": "success",
      "message": "Message deleted",
      "data": {
        "message_id": messageId,
        "deleted_for": deleteFor,
        "deleted_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.delete('/messages/$messageId', queryParams: {'delete_for': deleteFor});
  }

  @override
  Future<Map<String, dynamic>> markMessageAsRead({
    required String messageId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return {
      "status": "success",
      "message": "Message marked as read",
      "data": {
        "message_id": messageId,
        "read_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/messages/$messageId/read');
  }

  @override
  Future<Map<String, dynamic>> markConversationAsRead({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return {
      "status": "success",
      "message": "All messages marked as read",
      "data": {
        "conversation_id": conversationId,
        "messages_marked": 5,
        "marked_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/conversations/$conversationId/read-all');
  }

  @override
  Future<Map<String, dynamic>> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return {
      "status": "success",
      "message": "Reaction added",
      "data": {
        "message_id": messageId,
        "emoji": emoji,
        "user_id": "usr_123",
        "timestamp": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/messages/$messageId/reaction', body: {'emoji': emoji});
  }

  @override
  Future<Map<String, dynamic>> removeReaction({
    required String messageId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return {"status": "success", "message": "Reaction removed"};

    // Real implementation:
    // return await apiService.delete('/messages/$messageId/reaction');
  }

  @override
  Future<Map<String, dynamic>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    // No delay for typing indicator (real-time)
    return {
      "status": "success",
      "data": {
        "conversation_id": conversationId,
        "is_typing": isTyping,
        "expires_at":
            DateTime.now().add(const Duration(seconds: 5)).toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/conversations/$conversationId/typing', body: {'is_typing': isTyping});
  }

  @override
  Future<Map<String, dynamic>> muteConversation({
    required String conversationId,
    int? duration,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return {
      "status": "success",
      "message": "Conversation muted",
      "data": {
        "conversation_id": conversationId,
        "muted": true,
        "muted_until": duration != null
            ? DateTime.now().add(Duration(seconds: duration)).toIso8601String()
            : null
      }
    };

    // Real implementation:
    // return await apiService.post('/conversations/$conversationId/mute', body: {'duration': duration});
  }

  @override
  Future<Map<String, dynamic>> unmuteConversation({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return {"status": "success", "message": "Conversation unmuted"};

    // Real implementation:
    // return await apiService.delete('/conversations/$conversationId/mute');
  }

  @override
  Future<Map<String, dynamic>> pinConversation({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return {
      "status": "success",
      "message": "Conversation pinned",
      "data": {
        "conversation_id": conversationId,
        "pinned": true,
        "pinned_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/conversations/$conversationId/pin');
  }

  @override
  Future<Map<String, dynamic>> unpinConversation({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return {"status": "success", "message": "Conversation unpinned"};

    // Real implementation:
    // return await apiService.delete('/conversations/$conversationId/pin');
  }

  @override
  Future<Map<String, dynamic>> deleteConversation({
    required String conversationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "status": "success",
      "message": "Conversation deleted",
      "data": {
        "conversation_id": conversationId,
        "deleted_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.delete('/conversations/$conversationId');
  }

  @override
  Future<Map<String, dynamic>> blockUser({
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "status": "success",
      "message": "User blocked successfully",
      "data": {
        "user_id": userId,
        "blocked": true,
        "blocked_at": DateTime.now().toIso8601String()
      }
    };

    // Real implementation:
    // return await apiService.post('/users/$userId/block');
  }

  @override
  Future<Map<String, dynamic>> unblockUser({
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {"status": "success", "message": "User unblocked successfully"};

    // Real implementation:
    // return await apiService.delete('/users/$userId/block');
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockResponse = {
      "status": "success",
      "data": {
        "blocked_users": [
          {
            "user_id": "usr_999",
            "name": "Blocked User",
            "profile_picture":
                "https://cdn.farmmarket.com/profiles/usr_999.jpg",
            "blocked_at": DateTime.now()
                .subtract(const Duration(days: 7))
                .toIso8601String()
          }
        ],
        "total_count": 1
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final List<dynamic> blockedUsersData = data['blocked_users'];
    return blockedUsersData
        .map((json) => BlockedUserModel.fromJson(json))
        .toList();

    // Real implementation:
    // final response = await apiService.get('/users/blocked');
    // final List<dynamic> blockedUsersData = response['data']['blocked_users'];
    // return blockedUsersData.map((json) => BlockedUserModel.fromJson(json)).toList();
  }
}
