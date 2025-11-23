import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/conversation.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationParticipantModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'user_type')
  final String userType;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @JsonKey(name: 'last_seen')
  final DateTime? lastSeen;
  final bool verified;
  @JsonKey(name: 'response_rate')
  final int? responseRate;
  @JsonKey(name: 'response_time')
  final String? responseTime;

  ConversationParticipantModel({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.userType,
    required this.isOnline,
    this.lastSeen,
    required this.verified,
    this.responseRate,
    this.responseTime,
  });

  factory ConversationParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationParticipantModelToJson(this);

  ConversationParticipant toEntity() => ConversationParticipant(
        userId: userId,
        name: name,
        profilePicture: profilePicture,
        userType: userType,
        isOnline: isOnline,
        lastSeen: lastSeen,
        verified: verified,
        responseRate: responseRate,
        responseTime: responseTime,
      );
}

@JsonSerializable()
class ConversationOrderModel {
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  @JsonKey(name: 'items_count')
  final int? itemsCount;

  ConversationOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.itemsCount,
  });

  factory ConversationOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationOrderModelToJson(this);

  ConversationOrder toEntity() => ConversationOrder(
        orderId: orderId,
        orderNumber: orderNumber,
        status: status,
        totalAmount: totalAmount,
        itemsCount: itemsCount,
      );
}

@JsonSerializable()
class ConversationProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  final String name;
  final String? image;
  final int price;

  ConversationProductModel({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
  });

  factory ConversationProductModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationProductModelToJson(this);

  ConversationProduct toEntity() => ConversationProduct(
        productId: productId,
        name: name,
        image: image,
        price: price,
      );
}

@JsonSerializable()
class LastMessageModel {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'sender_id')
  final String senderId;
  @JsonKey(name: 'sender_name')
  final String senderName;
  final String type;
  final String? content;
  final String preview;
  final DateTime timestamp;
  @JsonKey(name: 'is_read')
  final bool isRead;

  LastMessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.type,
    this.content,
    required this.preview,
    required this.timestamp,
    required this.isRead,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$LastMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageModelToJson(this);

  LastMessage toEntity() => LastMessage(
        messageId: messageId,
        senderId: senderId,
        senderName: senderName,
        type: type,
        content: content,
        preview: preview,
        timestamp: timestamp,
        isRead: isRead,
      );
}

@JsonSerializable()
class TypingIndicatorModel {
  @JsonKey(name: 'is_typing')
  final bool isTyping;
  @JsonKey(name: 'user_id')
  final String? userId;

  TypingIndicatorModel({
    required this.isTyping,
    this.userId,
  });

  factory TypingIndicatorModel.fromJson(Map<String, dynamic> json) =>
      _$TypingIndicatorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TypingIndicatorModelToJson(this);

  TypingIndicator toEntity() => TypingIndicator(
        isTyping: isTyping,
        userId: userId,
      );
}

@JsonSerializable()
class ConversationModel {
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  final String type;
  final ConversationParticipantModel participant;
  final ConversationOrderModel? order;
  final ConversationProductModel? product;
  @JsonKey(name: 'last_message')
  final LastMessageModel? lastMessage;
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  final bool muted;
  final bool pinned;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ConversationModel({
    required this.conversationId,
    required this.type,
    required this.participant,
    this.order,
    this.product,
    this.lastMessage,
    required this.unreadCount,
    required this.muted,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  Conversation toEntity() => Conversation(
        conversationId: conversationId,
        type: type,
        participant: participant.toEntity(),
        order: order?.toEntity(),
        product: product?.toEntity(),
        lastMessage: lastMessage?.toEntity(),
        unreadCount: unreadCount,
        muted: muted,
        pinned: pinned,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

@JsonSerializable()
class ConversationDetailModel {
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  final String type;
  final ConversationParticipantModel participant;
  final ConversationOrderModel? order;
  final List<MessageModel> messages;
  @JsonKey(name: 'quick_replies')
  final List<String> quickReplies;
  @JsonKey(name: 'typing_indicator')
  final TypingIndicatorModel typingIndicator;
  @JsonKey(name: 'can_send_messages')
  final bool canSendMessages;
  final bool blocked;
  final bool muted;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  ConversationDetailModel({
    required this.conversationId,
    required this.type,
    required this.participant,
    this.order,
    required this.messages,
    required this.quickReplies,
    required this.typingIndicator,
    required this.canSendMessages,
    required this.blocked,
    required this.muted,
    required this.createdAt,
  });

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationDetailModelToJson(this);

  ConversationDetail toEntity() => ConversationDetail(
        conversationId: conversationId,
        type: type,
        participant: participant.toEntity(),
        order: order?.toEntity(),
        messages: messages.map((m) => m.toEntity()).toList(),
        quickReplies: quickReplies,
        typingIndicator: typingIndicator.toEntity(),
        canSendMessages: canSendMessages,
        blocked: blocked,
        muted: muted,
        createdAt: createdAt,
      );
}

@JsonSerializable()
class ConversationStatsModel {
  @JsonKey(name: 'total_conversations')
  final int totalConversations;
  @JsonKey(name: 'unread_conversations')
  final int unreadConversations;
  @JsonKey(name: 'total_unread_messages')
  final int totalUnreadMessages;

  ConversationStatsModel({
    required this.totalConversations,
    required this.unreadConversations,
    required this.totalUnreadMessages,
  });

  factory ConversationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationStatsModelToJson(this);

  ConversationStats toEntity() => ConversationStats(
        totalConversations: totalConversations,
        unreadConversations: unreadConversations,
        totalUnreadMessages: totalUnreadMessages,
      );
}

@JsonSerializable()
class BlockedUserModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'blocked_at')
  final DateTime blockedAt;

  BlockedUserModel({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedUserModelToJson(this);

  BlockedUser toEntity() => BlockedUser(
        userId: userId,
        name: name,
        profilePicture: profilePicture,
        blockedAt: blockedAt,
      );
}
