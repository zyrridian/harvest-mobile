import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/community/domain/usecases/get_post_comments_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/create_comment_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/toggle_comment_like_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/delete_comment_usecase.dart';
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
    final pendingId = 'pending_${DateTime.now().millisecondsSinceEpoch}';
    final pendingComment = CommunityComment(
      id: pendingId,
      postId: postId,
      userId: 'current_user',
      parentId: parentId,
      replyToUserId: replyToUserId,
      content: content,
      likesCount: 0,
      createdAt: DateTime.now(),
      user: const CommunityUser(id: 'current_user', name: 'You'),
      isPending: true,
    );

    state.maybeWhen(
      data: (data) {
        List<CommunityComment> updatedComments;
        if (parentId != null) {
          updatedComments = _addReplyToList(data.data, pendingComment);
        } else {
          updatedComments = [pendingComment, ...data.data];
        }
        state = PostDetailState.data(data.copyWith(data: updatedComments));
      },
      orElse: () {},
    );

    final useCase = ref.read(createCommentUseCaseProvider);
    final result = await useCase.call(
      postId: postId,
      content: content,
      parentId: parentId,
      replyToUserId: replyToUserId,
    );

    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            final updatedComments = _removeCommentFromList(data.data, pendingId);
            state = PostDetailState.data(data.copyWith(data: updatedComments));
          },
          orElse: () {},
        );
      },
      (comment) {
        state.maybeWhen(
          data: (data) {
            List<CommunityComment> updatedComments;
            if (parentId != null) {
              updatedComments = _replaceReplyInList(data.data, pendingId, comment);
            } else {
              updatedComments = data.data.map((c) => c.id == pendingId ? comment : c).toList();
            }
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

  List<CommunityComment> _replaceReplyInList(
      List<CommunityComment> comments, String oldId, CommunityComment newComment) {
    return comments.map((comment) {
      if (comment.id == newComment.parentId) {
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
          replies: comment.replies.map((r) => r.id == oldId ? newComment : r).toList(),
          isLikedByUser: comment.isLikedByUser,
        );
      }
      return comment;
    }).toList();
  }

  List<CommunityComment> _addReplyToList(
      List<CommunityComment> comments, CommunityComment newReply) {
    return comments.map((comment) {
      if (comment.id == newReply.parentId) {
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
          replies: [...comment.replies, newReply],
          isLikedByUser: comment.isLikedByUser,
        );
      }
      return comment;
    }).toList();
  }

  Future<void> deleteComment(String commentId) async {
    // 1. Optimistic delete: save old state
    List<CommunityComment> oldComments = [];
    state.maybeWhen(
      data: (data) {
        oldComments = data.data;
        final updatedComments = _removeCommentFromList(data.data, commentId);
        state = PostDetailState.data(data.copyWith(data: updatedComments));
      },
      orElse: () {},
    );

    // 2. Make API call
    final useCase = ref.read(deleteCommentUseCaseProvider);
    final result = await useCase.call(commentId: commentId);

    // 3. Revert if failed
    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            state = PostDetailState.data(data.copyWith(data: oldComments));
          },
          orElse: () {},
        );
      },
      (_) {},
    );
  }

  List<CommunityComment> _removeCommentFromList(List<CommunityComment> comments, String targetId) {
    final result = <CommunityComment>[];
    for (final comment in comments) {
      if (comment.id == targetId) continue;
      
      if (comment.replies.isNotEmpty) {
        result.add(CommunityComment(
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
          replies: _removeCommentFromList(comment.replies, targetId),
          isLikedByUser: comment.isLikedByUser,
        ));
      } else {
        result.add(comment);
      }
    }
    return result;
  }

  Future<void> toggleCommentLike(
      String commentId, bool isCurrentlyLiked) async {
    // 1. Optimistically update state
    state.maybeWhen(
      data: (data) {
        final updatedComments =
            _toggleLikeInList(data.data, commentId, isCurrentlyLiked);
        state = PostDetailState.data(data.copyWith(data: updatedComments));
      },
      orElse: () {},
    );

    // 2. Make API call
    final useCase = ref.read(toggleCommentLikeUseCaseProvider);
    final result = await useCase.call(
      commentId: commentId,
      isCurrentlyLiked: isCurrentlyLiked,
    );

    // 3. Revert if failed
    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            final revertedComments =
                _toggleLikeInList(data.data, commentId, !isCurrentlyLiked);
            state = PostDetailState.data(data.copyWith(data: revertedComments));
          },
          orElse: () {},
        );
      },
      (_) {},
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
