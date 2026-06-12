import 'package:equatable/equatable.dart';

class CommunityPost extends Equatable {
  final String id;
  final String userId;
  final String? farmerId;
  final String title;
  final String content;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CommunityUser user;
  final CommunityFarmer? farmer;
  final List<String> images;
  final List<CommunityTag> tags;
  final bool isLikedByUser;

  const CommunityPost({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        farmerId,
        title,
        content,
        likesCount,
        commentsCount,
        createdAt,
        updatedAt,
        user,
        farmer,
        images,
        tags,
        isLikedByUser,
      ];
}

class CommunityUser extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? userType;

  const CommunityUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.userType,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, userType];
}

class CommunityFarmer extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;

  const CommunityFarmer({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class CommunityTag extends Equatable {
  final String postId;
  final String tag;

  const CommunityTag({
    required this.postId,
    required this.tag,
  });

  @override
  List<Object?> get props => [postId, tag];
}
