import 'package:flutter_riverpod/flutter_riverpod.dart';
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
