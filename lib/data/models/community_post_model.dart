import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/community_post.dart';

part 'community_post_model.g.dart';

@JsonSerializable()
class CommunityPostModel {
  final String id;
  @JsonKey(name: 'farmer_id')
  final String farmerId;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @JsonKey(name: 'farmer_avatar')
  final String farmerAvatar;
  final String content;
  final List<String> images;
  final String? location;
  final String type;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'like_count')
  final int likeCount;
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @JsonKey(name: 'is_liked')
  final bool isLiked;
  final List<String> tags;

  const CommunityPostModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerAvatar,
    required this.content,
    this.images = const [],
    this.location,
    required this.type,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.tags = const [],
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostModelToJson(this);

  CommunityPost toEntity() {
    return CommunityPost(
      id: id,
      farmerId: farmerId,
      farmerName: farmerName,
      farmerAvatar: farmerAvatar,
      content: content,
      images: images,
      location: location,
      type: _parsePostType(type),
      createdAt: DateTime.parse(createdAt),
      likeCount: likeCount,
      commentCount: commentCount,
      isLiked: isLiked,
      tags: tags,
    );
  }

  factory CommunityPostModel.fromEntity(CommunityPost post) {
    return CommunityPostModel(
      id: post.id,
      farmerId: post.farmerId,
      farmerName: post.farmerName,
      farmerAvatar: post.farmerAvatar,
      content: post.content,
      images: post.images,
      location: post.location,
      type: post.type.name,
      createdAt: post.createdAt.toIso8601String(),
      likeCount: post.likeCount,
      commentCount: post.commentCount,
      isLiked: post.isLiked,
      tags: post.tags,
    );
  }

  static PostType _parsePostType(String type) {
    switch (type.toLowerCase()) {
      case 'announcement':
        return PostType.announcement;
      case 'harvest':
        return PostType.harvest;
      case 'tips':
        return PostType.tips;
      case 'event':
        return PostType.event;
      default:
        return PostType.general;
    }
  }
}
