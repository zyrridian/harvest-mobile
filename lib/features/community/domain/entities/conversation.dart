import 'package:equatable/equatable.dart';
import 'message.dart';

/// Conversation participant information
class ConversationParticipant extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final String userType; // producer, consumer, admin
  final bool isOnline;
  final DateTime? lastSeen;
  final bool verified;
  final int? responseRate;
  final String? responseTime;

  const ConversationParticipant({
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

  @override
  List<Object?> get props => [
        userId,
        name,
        profilePicture,
        userType,
        isOnline,
        lastSeen,
        verified,
        responseRate,
        responseTime,
      ];
}

/// Order reference in conversation
class ConversationOrder extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final int totalAmount;
  final int? itemsCount;

  const ConversationOrder({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.itemsCount,
  });

  @override
  List<Object?> get props =>
      [orderId, orderNumber, status, totalAmount, itemsCount];
}

/// Product reference in conversation
class ConversationProduct extends Equatable {
  final String productId;
  final String name;
  final String? image;
  final int price;

  const ConversationProduct({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, name, image, price];
}

/// Last message preview
class LastMessage extends Equatable {
  final String messageId;
  final String senderId;
  final String senderName;
  final String type;
  final String? content;
  final String preview;
  final DateTime timestamp;
  final bool isRead;

  const LastMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.type,
    this.content,
    required this.preview,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
        messageId,
        senderId,
        senderName,
        type,
        content,
        preview,
        timestamp,
        isRead,
      ];
}

/// Typing indicator
class TypingIndicator extends Equatable {
  final bool isTyping;
  final String? userId;

  const TypingIndicator({
    required this.isTyping,
    this.userId,
  });

  @override
  List<Object?> get props => [isTyping, userId];
}

/// Conversation
class Conversation extends Equatable {
  final String conversationId;
  final String type; // order, general
  final ConversationParticipant participant;
  final ConversationOrder? order;
  final ConversationProduct? product;
  final LastMessage? lastMessage;
  final int unreadCount;
  final bool muted;
  final bool pinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
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

  @override
  List<Object?> get props => [
        conversationId,
        type,
        participant,
        order,
        product,
        lastMessage,
        unreadCount,
        muted,
        pinned,
        createdAt,
        updatedAt,
      ];
}

/// Conversation detail with messages
class ConversationDetail extends Equatable {
  final String conversationId;
  final String type;
  final ConversationParticipant participant;
  final ConversationOrder? order;
  final List<Message> messages;
  final List<String> quickReplies;
  final TypingIndicator typingIndicator;
  final bool canSendMessages;
  final bool blocked;
  final bool muted;
  final DateTime createdAt;

  const ConversationDetail({
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

  @override
  List<Object?> get props => [
        conversationId,
        type,
        participant,
        order,
        messages,
        quickReplies,
        typingIndicator,
        canSendMessages,
        blocked,
        muted,
        createdAt,
      ];
}

/// Conversations statistics
class ConversationStats extends Equatable {
  final int totalConversations;
  final int unreadConversations;
  final int totalUnreadMessages;

  const ConversationStats({
    required this.totalConversations,
    required this.unreadConversations,
    required this.totalUnreadMessages,
  });

  @override
  List<Object?> get props => [
        totalConversations,
        unreadConversations,
        totalUnreadMessages,
      ];
}

/// Blocked user
class BlockedUser extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final DateTime blockedAt;

  const BlockedUser({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.blockedAt,
  });

  @override
  List<Object?> get props => [userId, name, profilePicture, blockedAt];
}
