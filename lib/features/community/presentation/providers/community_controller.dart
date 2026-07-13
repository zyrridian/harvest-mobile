import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/data/datasources/remote/community_remote_datasource.dart';
import 'package:harvest_app/features/community/data/datasources/local/community_local_datasource.dart';
import 'package:harvest_app/features/community/data/repositories/community_repository_impl.dart';
import 'package:harvest_app/features/community/domain/usecases/get_community_posts_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/toggle_post_like_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/create_post_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/edit_post_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/delete_post_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/get_post_comments_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/create_comment_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/toggle_comment_like_usecase.dart';
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

  String _mapFilterToApi(String uiFilter) {
    switch (uiFilter) {
      case 'Farmer Updates':
        return 'farmers';
      case 'Following':
        return 'following';
      case 'My Posts':
        return 'my_posts';
      case 'All Posts':
      default:
        return 'all';
    }
  }

  Future<void> _fetchPosts({int page = 1}) async {
    state = const CommunityState.loading();
    
    if (_currentFilter == 'Kitchen Recipes' || _currentFilter == 'recipes') {
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

    final apiFilter = _mapFilterToApi(_currentFilter);

    final useCase = ref.read(getCommunityPostsUseCaseProvider);
    final result = await useCase.call(
      page: page,
      limit: 10,
      filter: apiFilter,
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
    // 1. Optimistically update state
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

    // 2. Make API call
    final useCase = ref.read(togglePostLikeUseCaseProvider);
    final result = await useCase.call(postId: postId, isCurrentlyLiked: isCurrentlyLiked);

    // 3. Revert if failed
    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            final revertedPosts = data.data.map((post) {
              if (post.id == postId) {
                return CommunityPost(
                  id: post.id,
                  userId: post.userId,
                  farmerId: post.farmerId,
                  title: post.title,
                  content: post.content,
                  likesCount: isCurrentlyLiked ? post.likesCount + 1 : post.likesCount - 1,
                  commentsCount: post.commentsCount,
                  createdAt: post.createdAt,
                  updatedAt: post.updatedAt,
                  user: post.user,
                  farmer: post.farmer,
                  images: post.images,
                  tags: post.tags,
                  isLikedByUser: isCurrentlyLiked,
                );
              }
              return post;
            }).toList();
            state = CommunityState.data(data.copyWith(data: revertedPosts));
          },
          orElse: () {},
        );
      },
      (_) {},
    );
  }

  Future<void> editPost(String postId, String title, String content) async {
    // 1. Optimistic edit
    List<CommunityPost> oldPosts = [];
    state.maybeWhen(
      data: (data) {
        oldPosts = data.data;
        final updatedPosts = data.data.map((post) {
          if (post.id == postId) {
            return CommunityPost(
              id: post.id,
              userId: post.userId,
              farmerId: post.farmerId,
              title: title,
              content: content,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount,
              createdAt: post.createdAt,
              updatedAt: DateTime.now(),
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

    // 2. Make API call
    final useCase = ref.read(editPostUseCaseProvider);
    final result = await useCase.call(postId: postId, title: title, content: content);

    // 3. Revert if failed
    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            state = CommunityState.data(data.copyWith(data: oldPosts));
          },
          orElse: () {},
        );
        throw failure;
      },
      (editedPost) {
        state.maybeWhen(
          data: (data) {
            final updatedPosts = data.data.map((post) {
              return post.id == postId ? editedPost : post;
            }).toList();
            state = CommunityState.data(data.copyWith(data: updatedPosts));
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> deletePost(String postId) async {
    // 1. Optimistic delete
    List<CommunityPost> oldPosts = [];
    state.maybeWhen(
      data: (data) {
        oldPosts = data.data;
        final updatedPosts = data.data.where((p) => p.id != postId).toList();
        state = CommunityState.data(data.copyWith(data: updatedPosts));
      },
      orElse: () {},
    );

    // 2. Make API call
    final useCase = ref.read(deletePostUseCaseProvider);
    final result = await useCase.call(postId: postId);

    // 3. Revert if failed
    result.fold(
      (failure) {
        state.maybeWhen(
          data: (data) {
            state = CommunityState.data(data.copyWith(data: oldPosts));
          },
          orElse: () {},
        );
        throw failure;
      },
      (_) {},
    );
  }
}

// Local Data source provider
final communityLocalDataSourceProvider = Provider<CommunityLocalDataSource>((ref) {
  return CommunityLocalDataSourceImpl(sharedPreferences: ref.watch(sharedPreferencesProvider));
});

// Remote Data source provider
final communityRemoteDataSourceProvider = Provider<CommunityRemoteDataSource>((ref) {
  return CommunityRemoteDataSourceImpl(ref.watch(dioProvider));
});

// Repository provider
final communityRepositoryProvider = Provider<CommunityRepositoryImpl>((ref) {
  return CommunityRepositoryImpl(
    remoteDataSource: ref.watch(communityRemoteDataSourceProvider),
    localDataSource: ref.watch(communityLocalDataSourceProvider),
  );
});

// Use cases providers
final getCommunityPostsUseCaseProvider = Provider<GetCommunityPostsUseCase>((ref) {
  return GetCommunityPostsUseCase(ref.watch(communityRepositoryProvider));
});

final togglePostLikeUseCaseProvider = Provider<TogglePostLikeUseCase>((ref) {
  return TogglePostLikeUseCase(ref.watch(communityRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.watch(communityRepositoryProvider));
});

final editPostUseCaseProvider = Provider<EditPostUseCase>((ref) {
  return EditPostUseCase(ref.watch(communityRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.watch(communityRepositoryProvider));
});

final getPostCommentsUseCaseProvider = Provider<GetPostCommentsUseCase>((ref) {
  return GetPostCommentsUseCase(ref.watch(communityRepositoryProvider));
});

final createCommentUseCaseProvider = Provider<CreateCommentUseCase>((ref) {
  return CreateCommentUseCase(ref.watch(communityRepositoryProvider));
});

final toggleCommentLikeUseCaseProvider = Provider<ToggleCommentLikeUseCase>((ref) {
  return ToggleCommentLikeUseCase(ref.watch(communityRepositoryProvider));
});
