import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/community/domain/usecases/get_community_posts_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/toggle_post_like_usecase.dart';
import 'package:harvest_app/features/community/presentation/providers/community_providers.dart'; // To get usecase providers
import 'package:harvest_app/domain/entities/paginated_response.dart';
import 'community_state.dart';

part 'community_controller.g.dart';

@riverpod
class CommunityController extends _$CommunityController {
  String _currentFilter = 'all';
  String? _currentTag;

  @override
  CommunityState build() {
    _fetchPosts();
    return const CommunityState.loading();
  }

  Future<void> _fetchPosts({int page = 1}) async {
    state = const CommunityState.loading();
    
    if (_currentFilter == 'recipes') {
      state = const CommunityState.data(PaginatedResponse<CommunityPost>(
        data: [],
        pagination: Pagination(
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
        ),
      ));
      return;
    }

    final useCase = ref.read(getCommunityPostsUseCaseProvider);
    final result = await useCase.call(
      page: page,
      limit: 10,
      filter: _currentFilter,
      tag: _currentTag,
    );

    result.fold(
      (failure) => state = CommunityState.error(failure.message),
      (data) => state = CommunityState.data(data),
    );
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _currentTag = null; // Reset tag when changing main filter
    _fetchPosts();
  }

  void setTag(String tag) {
    _currentTag = tag.isEmpty ? null : tag;
    _fetchPosts();
  }

  void incrementCommentCount(String postId) {
    state.maybeWhen(
      data: (data) {
        final updatedPosts = data.data.map((post) {
          if (post.id == postId) {
            return CommunityPost(
              id: post.id,
              userId: post.userId,
              farmerId: post.farmerId,
              title: post.title,
              content: post.content,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount + 1,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              user: post.user,
              farmer: post.farmer,
              images: post.images,
              tags: post.tags,
              isLikedByUser: post.isLikedByUser,
            );
          }
          return post;
        }).toList();
        state = CommunityState.data(data.copyWith(data: updatedPosts));
      },
      orElse: () {},
    );
  }

  Future<void> toggleLike(String postId, bool isCurrentlyLiked) async {
    final useCase = ref.read(togglePostLikeUseCaseProvider);
    final result = await useCase.call(postId: postId, isCurrentlyLiked: isCurrentlyLiked);

    result.fold(
      (failure) {
        // Handle error, maybe show snackbar (would need to expose error differently or let UI handle it)
      },
      (_) {
        // Optimistically update state
        state.maybeWhen(
          data: (data) {
            final updatedPosts = data.data.map((post) {
              if (post.id == postId) {
                return CommunityPost(
                  id: post.id,
                  userId: post.userId,
                  farmerId: post.farmerId,
                  title: post.title,
                  content: post.content,
                  likesCount: isCurrentlyLiked ? post.likesCount - 1 : post.likesCount + 1,
                  commentsCount: post.commentsCount,
                  createdAt: post.createdAt,
                  updatedAt: post.updatedAt,
                  user: post.user,
                  farmer: post.farmer,
                  images: post.images,
                  tags: post.tags,
                  isLikedByUser: !isCurrentlyLiked,
                );
              }
              return post;
            }).toList();
            
            state = CommunityState.data(data.copyWith(data: updatedPosts));
          },
          orElse: () {},
        );
      },
    );
  }
}
