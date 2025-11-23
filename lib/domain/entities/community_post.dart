import 'package:equatable/equatable.dart';

class CommunityPost extends Equatable {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerAvatar;
  final String content;
  final List<String> images;
  final String? location;
  final PostType type;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final List<String> tags;

  const CommunityPost({
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

  @override
  List<Object?> get props => [
        id,
        farmerId,
        farmerName,
        farmerAvatar,
        content,
        images,
        location,
        type,
        createdAt,
        likeCount,
        commentCount,
        isLiked,
        tags,
      ];
}

enum PostType {
  announcement, // Farm news, updates
  harvest, // Harvest updates
  tips, // Farming tips
  event, // Farm events
  general, // General posts
}
