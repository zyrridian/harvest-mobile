import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/community/domain/usecases/get_post_comments_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/create_comment_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/toggle_comment_like_usecase.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:harvest_app/features/community/domain/entities/community_comment.dart';
import 'package:harvest_app/domain/entities/paginated_response.dart';
import 'post_detail_state.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  @override
  PostDetailState build(String postId) {
    _fetchComments();
    return const PostDetailState.loading();
  }

  Future<void> _fetchComments({int page = 1}) async {
    state = const PostDetailState.loading();
    final useCase = ref.read(getPostCommentsUseCaseProvider);
    final result = await useCase.call(
      postId: postId,
      page: page,
      limit: 50,
    );

    result.fold(
      (failure) => state = PostDetailState.error(failure.message),
      (data) => state = PostDetailState.data(data),
    );
  }

  Future<void> addComment(String content,
      {String? parentId, String? replyToUserId}) async {
    final useCase = ref.read(createCommentUseCaseProvider);
    final result = await useCase.call(
      postId: postId,
      content: content,
      parentId: parentId,
      replyToUserId: replyToUserId,
    );

    result.fold(
      (failure) {
        // Handle error (e.g., via a side effect listener)
      },
      (comment) {
        state.maybeWhen(
          data: (data) {
            final updatedComments = [comment, ...data.data];
            state = PostDetailState.data(data.copyWith(data: updatedComments));
          },
          orElse: () => _fetchComments(),
        );
        ref
            .read(communityControllerProvider.notifier)
            .incrementCommentCount(postId);
      },
    );
  }

  Future<void> toggleCommentLike(
      String commentId, bool isCurrentlyLiked) async {
    final useCase = ref.read(toggleCommentLikeUseCaseProvider);
    final result = await useCase.call(
      commentId: commentId,
      isCurrentlyLiked: isCurrentlyLiked,
    );

    result.fold(
      (failure) {},
      (_) {
        // Optimistically update
        state.maybeWhen(
          data: (data) {
            final updatedComments =
                _toggleLikeInList(data.data, commentId, isCurrentlyLiked);
            state = PostDetailState.data(data.copyWith(data: updatedComments));
          },
          orElse: () {},
        );
      },
    );
  }

  List<CommunityComment> _toggleLikeInList(
      List<CommunityComment> comments, String targetId, bool isCurrentlyLiked) {
    return comments.map((comment) {
      if (comment.id == targetId) {
        return CommunityComment(
          id: comment.id,
          postId: comment.postId,
          userId: comment.userId,
          parentId: comment.parentId,
          replyToUserId: comment.replyToUserId,
          content: comment.content,
          likesCount: isCurrentlyLiked
              ? comment.likesCount - 1
              : comment.likesCount + 1,
          createdAt: comment.createdAt,
          user: comment.user,
          replyToUser: comment.replyToUser,
          replies: comment.replies,
          isLikedByUser: !isCurrentlyLiked,
        );
      }

      // Also check nested replies
      if (comment.replies.isNotEmpty) {
        return CommunityComment(
          id: comment.id,
          postId: comment.postId,
          userId: comment.userId,
          parentId: comment.parentId,
          replyToUserId: comment.replyToUserId,
          content: comment.content,
          likesCount: comment.likesCount,
          createdAt: comment.createdAt,
          user: comment.user,
          replyToUser: comment.replyToUser,
          replies:
              _toggleLikeInList(comment.replies, targetId, isCurrentlyLiked),
          isLikedByUser: comment.isLikedByUser,
        );
      }

      return comment;
    }).toList();
  }
}
