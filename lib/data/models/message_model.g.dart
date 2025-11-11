// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageUserModel _$MessageUserModelFromJson(Map<String, dynamic> json) =>
    MessageUserModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$MessageUserModelToJson(MessageUserModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
    };

MessageReactionModel _$MessageReactionModelFromJson(
        Map<String, dynamic> json) =>
    MessageReactionModel(
      emoji: json['emoji'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageReactionModelToJson(
        MessageReactionModel instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'user_id': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

MessageProductModel _$MessageProductModelFromJson(Map<String, dynamic> json) =>
    MessageProductModel(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      price: (json['price'] as num).toInt(),
      unit: json['unit'] as String,
      availability: json['availability'] as String,
    );

Map<String, dynamic> _$MessageProductModelToJson(
        MessageProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'unit': instance.unit,
      'availability': instance.availability,
    };

MessageOrderModel _$MessageOrderModelFromJson(Map<String, dynamic> json) =>
    MessageOrderModel(
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      itemsCount: (json['items_count'] as num).toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MessageOrderModelToJson(MessageOrderModel instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'items_count': instance.itemsCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };

MessageImageModel _$MessageImageModelFromJson(Map<String, dynamic> json) =>
    MessageImageModel(
      imageId: json['image_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageImageModelToJson(MessageImageModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
    };

MessageVoiceModel _$MessageVoiceModelFromJson(Map<String, dynamic> json) =>
    MessageVoiceModel(
      url: json['url'] as String,
      duration: (json['duration'] as num).toInt(),
      waveform: (json['waveform'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$MessageVoiceModelToJson(MessageVoiceModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'duration': instance.duration,
      'waveform': instance.waveform,
    };

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      messageId: json['message_id'] as String,
      sender: MessageUserModel.fromJson(json['sender'] as Map<String, dynamic>),
      type: json['type'] as String,
      content: json['content'] as String?,
      product: json['product'] == null
          ? null
          : MessageProductModel.fromJson(
              json['product'] as Map<String, dynamic>),
      order: json['order'] == null
          ? null
          : MessageOrderModel.fromJson(json['order'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MessageImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      voice: json['voice'] == null
          ? null
          : MessageVoiceModel.fromJson(json['voice'] as Map<String, dynamic>),
      text: json['text'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      isEdited: json['is_edited'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isPlayed: json['is_played'] as bool?,
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((e) => MessageReactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      replyToMessageId: json['reply_to_message_id'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'sender': instance.sender,
      'type': instance.type,
      'content': instance.content,
      'product': instance.product,
      'order': instance.order,
      'images': instance.images,
      'voice': instance.voice,
      'text': instance.text,
      'timestamp': instance.timestamp.toIso8601String(),
      'is_read': instance.isRead,
      'read_at': instance.readAt?.toIso8601String(),
      'is_edited': instance.isEdited,
      'is_deleted': instance.isDeleted,
      'is_played': instance.isPlayed,
      'reactions': instance.reactions,
      'reply_to_message_id': instance.replyToMessageId,
    };
