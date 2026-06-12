import 'package:json_annotation/json_annotation.dart';
import 'community_post_model.dart';
import '../../domain/entities/community_comment.dart';

part 'community_comment_model.g.dart';

@JsonSerializable()
class CommunityCommentModel {
  final String id;
  final String postId;
  final String userId;
  final String? parentId;
  final String? replyToUserId;
  final String content;
  final int likesCount;
  final String createdAt;
  final CommunityUserModel user;
  final CommunityUserModel? replyToUser;
  final List<CommunityCommentModel>? replies;
  @JsonKey(name: 'is_liked_by_user')
  final bool isLikedByUser;

  const CommunityCommentModel({
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
    this.replies,
    this.isLikedByUser = false,
  });

  factory CommunityCommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityCommentModelToJson(this);

  CommunityComment toEntity() {
    return CommunityComment(
      id: id,
      postId: postId,
      userId: userId,
      parentId: parentId,
      replyToUserId: replyToUserId,
      content: content,
      likesCount: likesCount,
      createdAt: DateTime.parse(createdAt),
      user: user.toEntity(),
      replyToUser: replyToUser?.toEntity(),
      replies: replies?.map((r) => r.toEntity()).toList() ?? [],
      isLikedByUser: isLikedByUser,
    );
  }
}
