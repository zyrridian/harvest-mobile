import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/community_post.dart';

part 'community_post_model.g.dart';

@JsonSerializable()
class CommunityPostModel {
  final String id;
  final String userId;
  final String? farmerId;
  final String title;
  final String content;
  final int likesCount;
  final int commentsCount;
  final String createdAt;
  final String updatedAt;
  final CommunityUserModel user;
  final CommunityFarmerModel? farmer;
  final List<CommunityPostImageModel> images;
  final List<CommunityTagModel> tags;
  @JsonKey(name: 'is_liked_by_user')
  final bool isLikedByUser;

  const CommunityPostModel({
    required this.id,
    required this.userId,
    this.farmerId,
    required this.title,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.farmer,
    this.images = const [],
    this.tags = const [],
    this.isLikedByUser = false,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostModelToJson(this);

  CommunityPost toEntity() {
    return CommunityPost(
      id: id,
      userId: userId,
      farmerId: farmerId,
      title: title,
      content: content,
      likesCount: likesCount,
      commentsCount: commentsCount,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      user: user.toEntity(),
      farmer: farmer?.toEntity(),
      images: images.map((i) => i.url).toList(),
      tags: tags.map((t) => t.toEntity()).toList(),
      isLikedByUser: isLikedByUser,
    );
  }

  factory CommunityPostModel.fromEntity(CommunityPost entity) {
    return CommunityPostModel(
      id: entity.id,
      userId: entity.userId,
      farmerId: entity.farmerId,
      title: entity.title,
      content: entity.content,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      user: CommunityUserModel.fromEntity(entity.user),
      farmer: entity.farmer != null
          ? CommunityFarmerModel.fromEntity(entity.farmer!)
          : null,
      images: entity.images.map((url) => CommunityPostImageModel(id: '', postId: entity.id, url: url)).toList(),
      tags: entity.tags.map((t) => CommunityTagModel.fromEntity(t)).toList(),
      isLikedByUser: entity.isLikedByUser,
    );
  }
}

@JsonSerializable()
class CommunityUserModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? userType;

  const CommunityUserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.userType,
  });

  factory CommunityUserModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityUserModelToJson(this);

  CommunityUser toEntity() {
    return CommunityUser(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      userType: userType,
    );
  }

  factory CommunityUserModel.fromEntity(CommunityUser entity) {
    return CommunityUserModel(
      id: entity.id,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      userType: entity.userType,
    );
  }
}

@JsonSerializable()
class CommunityFarmerModel {
  final String id;
  final String name;
  @JsonKey(name: 'profileImage')
  final String? profileImage;

  const CommunityFarmerModel({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory CommunityFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityFarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityFarmerModelToJson(this);

  CommunityFarmer toEntity() {
    return CommunityFarmer(
      id: id,
      name: name,
      profileImage: profileImage,
    );
  }

  factory CommunityFarmerModel.fromEntity(CommunityFarmer entity) {
    return CommunityFarmerModel(
      id: entity.id,
      name: entity.name,
      profileImage: entity.profileImage,
    );
  }
}

@JsonSerializable()
class CommunityTagModel {
  final String postId;
  final String tag;

  const CommunityTagModel({
    required this.postId,
    required this.tag,
  });

  factory CommunityTagModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityTagModelToJson(this);

  CommunityTag toEntity() {
    return CommunityTag(
      postId: postId,
      tag: tag,
    );
  }

  factory CommunityTagModel.fromEntity(CommunityTag entity) {
    return CommunityTagModel(
      postId: entity.postId,
      tag: entity.tag,
    );
  }
}

@JsonSerializable()
class CommunityPostImageModel {
  final String id;
  final String postId;
  final String url;
  final String? thumbnailUrl;
  final int? displayOrder;

  const CommunityPostImageModel({
    required this.id,
    required this.postId,
    required this.url,
    this.thumbnailUrl,
    this.displayOrder,
  });

  factory CommunityPostImageModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostImageModelToJson(this);
}

