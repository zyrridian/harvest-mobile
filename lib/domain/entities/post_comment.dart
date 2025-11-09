import 'package:equatable/equatable.dart';

class PostComment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;

  const PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
    this.isLiked = false,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        userName,
        userAvatar,
        content,
        createdAt,
        likeCount,
        isLiked,
      ];
}
