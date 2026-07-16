import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/post_comment.dart';

part 'post_comment_model.g.dart';

@JsonSerializable()
class PostCommentModel {
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'user_avatar')
  final String? userAvatar;
  final String content;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'like_count')
  final int likeCount;
  @JsonKey(name: 'is_liked')
  final bool isLiked;

  const PostCommentModel({
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

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentModelToJson(this);

  PostComment toEntity() {
    return PostComment(
      id: id,
      postId: postId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      createdAt: DateTime.parse(createdAt),
      likeCount: likeCount,
      isLiked: isLiked,
    );
  }

  factory PostCommentModel.fromEntity(PostComment comment) {
    return PostCommentModel(
      id: comment.id,
      postId: comment.postId,
      userId: comment.userId,
      userName: comment.userName,
      userAvatar: comment.userAvatar,
      content: comment.content,
      createdAt: comment.createdAt.toIso8601String(),
      likeCount: comment.likeCount,
      isLiked: comment.isLiked,
    );
  }
}
