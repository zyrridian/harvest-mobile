// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationParticipantModel _$ConversationParticipantModelFromJson(
        Map<String, dynamic> json) =>
    ConversationParticipantModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      userType: json['user_type'] as String,
      isOnline: json['is_online'] as bool,
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
      verified: json['verified'] as bool,
      responseRate: (json['response_rate'] as num?)?.toInt(),
      responseTime: json['response_time'] as String?,
    );

Map<String, dynamic> _$ConversationParticipantModelToJson(
        ConversationParticipantModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'user_type': instance.userType,
      'is_online': instance.isOnline,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'verified': instance.verified,
      'response_rate': instance.responseRate,
      'response_time': instance.responseTime,
    };

ConversationOrderModel _$ConversationOrderModelFromJson(
        Map<String, dynamic> json) =>
    ConversationOrderModel(
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      itemsCount: (json['items_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationOrderModelToJson(
        ConversationOrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'items_count': instance.itemsCount,
    };

ConversationProductModel _$ConversationProductModelFromJson(
        Map<String, dynamic> json) =>
    ConversationProductModel(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationProductModelToJson(
        ConversationProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
    };

LastMessageModel _$LastMessageModelFromJson(Map<String, dynamic> json) =>
    LastMessageModel(
      messageId: json['message_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      type: json['type'] as String,
      content: json['content'] as String?,
      preview: json['preview'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );

Map<String, dynamic> _$LastMessageModelToJson(LastMessageModel instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'type': instance.type,
      'content': instance.content,
      'preview': instance.preview,
      'timestamp': instance.timestamp.toIso8601String(),
      'is_read': instance.isRead,
    };

TypingIndicatorModel _$TypingIndicatorModelFromJson(
        Map<String, dynamic> json) =>
    TypingIndicatorModel(
      isTyping: json['is_typing'] as bool,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$TypingIndicatorModelToJson(
        TypingIndicatorModel instance) =>
    <String, dynamic>{
      'is_typing': instance.isTyping,
      'user_id': instance.userId,
    };

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      conversationId: json['conversation_id'] as String,
      type: json['type'] as String,
      participant: ConversationParticipantModel.fromJson(
          json['participant'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : ConversationOrderModel.fromJson(
              json['order'] as Map<String, dynamic>),
      product: json['product'] == null
          ? null
          : ConversationProductModel.fromJson(
              json['product'] as Map<String, dynamic>),
      lastMessage: json['last_message'] == null
          ? null
          : LastMessageModel.fromJson(
              json['last_message'] as Map<String, dynamic>),
      unreadCount: (json['unread_count'] as num).toInt(),
      muted: json['muted'] as bool,
      pinned: json['pinned'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'type': instance.type,
      'participant': instance.participant,
      'order': instance.order,
      'product': instance.product,
      'last_message': instance.lastMessage,
      'unread_count': instance.unreadCount,
      'muted': instance.muted,
      'pinned': instance.pinned,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ConversationDetailModel _$ConversationDetailModelFromJson(
        Map<String, dynamic> json) =>
    ConversationDetailModel(
      conversationId: json['conversation_id'] as String,
      type: json['type'] as String,
      participant: ConversationParticipantModel.fromJson(
          json['participant'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : ConversationOrderModel.fromJson(
              json['order'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quickReplies: (json['quick_replies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      typingIndicator: TypingIndicatorModel.fromJson(
          json['typing_indicator'] as Map<String, dynamic>),
      canSendMessages: json['can_send_messages'] as bool,
      blocked: json['blocked'] as bool,
      muted: json['muted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ConversationDetailModelToJson(
        ConversationDetailModel instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'type': instance.type,
      'participant': instance.participant,
      'order': instance.order,
      'messages': instance.messages,
      'quick_replies': instance.quickReplies,
      'typing_indicator': instance.typingIndicator,
      'can_send_messages': instance.canSendMessages,
      'blocked': instance.blocked,
      'muted': instance.muted,
      'created_at': instance.createdAt.toIso8601String(),
    };

ConversationStatsModel _$ConversationStatsModelFromJson(
        Map<String, dynamic> json) =>
    ConversationStatsModel(
      totalConversations: (json['total_conversations'] as num).toInt(),
      unreadConversations: (json['unread_conversations'] as num).toInt(),
      totalUnreadMessages: (json['total_unread_messages'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationStatsModelToJson(
        ConversationStatsModel instance) =>
    <String, dynamic>{
      'total_conversations': instance.totalConversations,
      'unread_conversations': instance.unreadConversations,
      'total_unread_messages': instance.totalUnreadMessages,
    };

BlockedUserModel _$BlockedUserModelFromJson(Map<String, dynamic> json) =>
    BlockedUserModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      blockedAt: DateTime.parse(json['blocked_at'] as String),
    );

Map<String, dynamic> _$BlockedUserModelToJson(BlockedUserModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'blocked_at': instance.blockedAt.toIso8601String(),
    };
