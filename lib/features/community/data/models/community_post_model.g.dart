// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityPostModel _$CommunityPostModelFromJson(Map<String, dynamic> json) =>
    CommunityPostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      farmerId: json['farmerId'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      user: CommunityUserModel.fromJson(json['user'] as Map<String, dynamic>),
      farmer: json['farmer'] == null
          ? null
          : CommunityFarmerModel.fromJson(
              json['farmer'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) =>
                  CommunityPostImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map(
                  (e) => CommunityTagModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLikedByUser: json['is_liked_by_user'] as bool? ?? false,
    );

Map<String, dynamic> _$CommunityPostModelToJson(CommunityPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'farmerId': instance.farmerId,
      'title': instance.title,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'user': instance.user,
      'farmer': instance.farmer,
      'images': instance.images,
      'tags': instance.tags,
      'is_liked_by_user': instance.isLikedByUser,
    };

CommunityUserModel _$CommunityUserModelFromJson(Map<String, dynamic> json) =>
    CommunityUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      userType: json['userType'] as String?,
    );

Map<String, dynamic> _$CommunityUserModelToJson(CommunityUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'userType': instance.userType,
    };

CommunityFarmerModel _$CommunityFarmerModelFromJson(
        Map<String, dynamic> json) =>
    CommunityFarmerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$CommunityFarmerModelToJson(
        CommunityFarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
    };

CommunityTagModel _$CommunityTagModelFromJson(Map<String, dynamic> json) =>
    CommunityTagModel(
      postId: json['postId'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$CommunityTagModelToJson(CommunityTagModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'tag': instance.tag,
    };

CommunityPostImageModel _$CommunityPostImageModelFromJson(
        Map<String, dynamic> json) =>
    CommunityPostImageModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommunityPostImageModelToJson(
        CommunityPostImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'displayOrder': instance.displayOrder,
    };
