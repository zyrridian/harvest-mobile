import 'package:equatable/equatable.dart';

/// Message sender/recipient information
class MessageUser extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;

  const MessageUser({
    required this.userId,
    required this.name,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [userId, name, profilePicture];
}

/// Reaction to a message
class MessageReaction extends Equatable {
  final String emoji;
  final String userId;
  final DateTime timestamp;

  const MessageReaction({
    required this.emoji,
    required this.userId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [emoji, userId, timestamp];
}

/// Product shared in message
class MessageProduct extends Equatable {
  final String productId;
  final String name;
  final String? image;
  final int price;
  final String unit;
  final String availability;

  const MessageProduct({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
    required this.unit,
    required this.availability,
  });

  @override
  List<Object?> get props =>
      [productId, name, image, price, unit, availability];
}

/// Order shared in message
class MessageOrder extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final int totalAmount;
  final int itemsCount;
  final DateTime? createdAt;

  const MessageOrder({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.itemsCount,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        status,
        totalAmount,
        itemsCount,
        createdAt,
      ];
}

/// Image in message
class MessageImage extends Equatable {
  final String imageId;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;

  const MessageImage({
    required this.imageId,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => [imageId, url, thumbnailUrl, width, height];
}

/// Voice message
class MessageVoice extends Equatable {
  final String url;
  final int duration; // seconds
  final List<double>? waveform;

  const MessageVoice({
    required this.url,
    required this.duration,
    this.waveform,
  });

  @override
  List<Object?> get props => [url, duration, waveform];
}

/// Chat message
class Message extends Equatable {
  final String messageId;
  final MessageUser sender;
  final String type; // text, image, product, order, voice
  final String? content;
  final MessageProduct? product;
  final MessageOrder? order;
  final List<MessageImage>? images;
  final MessageVoice? voice;
  final String? text; // Additional text with product/order/image
  final DateTime timestamp;
  final bool isRead;
  final DateTime? readAt;
  final bool isEdited;
  final bool isDeleted;
  final bool? isPlayed; // For voice messages
  final List<MessageReaction>? reactions;
  final String? replyToMessageId;

  const Message({
    required this.messageId,
    required this.sender,
    required this.type,
    this.content,
    this.product,
    this.order,
    this.images,
    this.voice,
    this.text,
    required this.timestamp,
    required this.isRead,
    this.readAt,
    this.isEdited = false,
    this.isDeleted = false,
    this.isPlayed,
    this.reactions,
    this.replyToMessageId,
  });

  @override
  List<Object?> get props => [
        messageId,
        sender,
        type,
        content,
        product,
        order,
        images,
        voice,
        text,
        timestamp,
        isRead,
        readAt,
        isEdited,
        isDeleted,
        isPlayed,
        reactions,
        replyToMessageId,
      ];
}
