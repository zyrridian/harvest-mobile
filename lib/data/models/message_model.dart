import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageUserModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  MessageUserModel({
    required this.userId,
    required this.name,
    this.profilePicture,
  });

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageUserModelToJson(this);

  MessageUser toEntity() => MessageUser(
        userId: userId,
        name: name,
        profilePicture: profilePicture,
      );
}

@JsonSerializable()
class MessageReactionModel {
  final String emoji;
  @JsonKey(name: 'user_id')
  final String userId;
  final DateTime timestamp;

  MessageReactionModel({
    required this.emoji,
    required this.userId,
    required this.timestamp,
  });

  factory MessageReactionModel.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageReactionModelToJson(this);

  MessageReaction toEntity() => MessageReaction(
        emoji: emoji,
        userId: userId,
        timestamp: timestamp,
      );
}

@JsonSerializable()
class MessageProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  final String name;
  final String? image;
  final int price;
  final String unit;
  final String availability;

  MessageProductModel({
    required this.productId,
    required this.name,
    this.image,
    required this.price,
    required this.unit,
    required this.availability,
  });

  factory MessageProductModel.fromJson(Map<String, dynamic> json) =>
      _$MessageProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageProductModelToJson(this);

  MessageProduct toEntity() => MessageProduct(
        productId: productId,
        name: name,
        image: image,
        price: price,
        unit: unit,
        availability: availability,
      );
}

@JsonSerializable()
class MessageOrderModel {
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  @JsonKey(name: 'items_count')
  final int itemsCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  MessageOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.itemsCount,
    this.createdAt,
  });

  factory MessageOrderModel.fromJson(Map<String, dynamic> json) =>
      _$MessageOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageOrderModelToJson(this);

  MessageOrder toEntity() => MessageOrder(
        orderId: orderId,
        orderNumber: orderNumber,
        status: status,
        totalAmount: totalAmount,
        itemsCount: itemsCount,
        createdAt: createdAt,
      );
}

@JsonSerializable()
class MessageImageModel {
  @JsonKey(name: 'image_id')
  final String imageId;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  final int? width;
  final int? height;

  MessageImageModel({
    required this.imageId,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
  });

  factory MessageImageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageImageModelToJson(this);

  MessageImage toEntity() => MessageImage(
        imageId: imageId,
        url: url,
        thumbnailUrl: thumbnailUrl,
        width: width,
        height: height,
      );
}

@JsonSerializable()
class MessageVoiceModel {
  final String url;
  final int duration;
  final List<double>? waveform;

  MessageVoiceModel({
    required this.url,
    required this.duration,
    this.waveform,
  });

  factory MessageVoiceModel.fromJson(Map<String, dynamic> json) =>
      _$MessageVoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageVoiceModelToJson(this);

  MessageVoice toEntity() => MessageVoice(
        url: url,
        duration: duration,
        waveform: waveform,
      );
}

@JsonSerializable()
class MessageModel {
  @JsonKey(name: 'message_id')
  final String messageId;
  final MessageUserModel sender;
  final String type;
  final String? content;
  final MessageProductModel? product;
  final MessageOrderModel? order;
  final List<MessageImageModel>? images;
  final MessageVoiceModel? voice;
  final String? text;
  final DateTime timestamp;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @JsonKey(name: 'is_edited')
  final bool isEdited;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @JsonKey(name: 'is_played')
  final bool? isPlayed;
  final List<MessageReactionModel>? reactions;
  @JsonKey(name: 'reply_to_message_id')
  final String? replyToMessageId;

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  Message toEntity() => Message(
        messageId: messageId,
        sender: sender.toEntity(),
        type: type,
        content: content,
        product: product?.toEntity(),
        order: order?.toEntity(),
        images: images?.map((img) => img.toEntity()).toList(),
        voice: voice?.toEntity(),
        text: text,
        timestamp: timestamp,
        isRead: isRead,
        readAt: readAt,
        isEdited: isEdited,
        isDeleted: isDeleted,
        isPlayed: isPlayed,
        reactions: reactions?.map((r) => r.toEntity()).toList(),
        replyToMessageId: replyToMessageId,
      );
}
