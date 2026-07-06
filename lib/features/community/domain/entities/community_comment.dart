import 'package:equatable/equatable.dart';
import 'community_post.dart';

class CommunityComment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String? parentId;
  final String? replyToUserId;
  final String content;
  final int likesCount;
  final DateTime createdAt;
  final CommunityUser user;
  final CommunityUser? replyToUser;
  final List<CommunityComment> replies;
  final bool isLikedByUser;

  const CommunityComment({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    this.replyToUserId,
    required this.content,
    required this.likesCount,
    required this.createdAt,
    required this.user,
    this.replyToUser,
    this.replies = const [],
    this.isLikedByUser = false,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        parentId,
        replyToUserId,
        content,
        likesCount,
        createdAt,
        user,
        replyToUser,
        replies,
        isLikedByUser,
      ];
}
