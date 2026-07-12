// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityCommentModel _$CommunityCommentModelFromJson(
        Map<String, dynamic> json) =>
    CommunityCommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      parentId: json['parentId'] as String?,
      replyToUserId: json['replyToUserId'] as String?,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      user: CommunityUserModel.fromJson(json['user'] as Map<String, dynamic>),
      replyToUser: json['replyToUser'] == null
          ? null
          : CommunityUserModel.fromJson(
              json['replyToUser'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map(
              (e) => CommunityCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLikedByUser: json['is_liked_by_user'] as bool? ?? false,
    );

Map<String, dynamic> _$CommunityCommentModelToJson(
        CommunityCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'replyToUserId': instance.replyToUserId,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt,
      'user': instance.user,
      'replyToUser': instance.replyToUser,
      'replies': instance.replies,
      'is_liked_by_user': instance.isLikedByUser,
    };
