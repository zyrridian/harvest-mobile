import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../core/providers/db_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/community/data/datasources/remote/community_remote_datasource.dart';
import '../../../../features/community/data/datasources/local/community_local_datasource.dart';
import '../../../../data/repositories/community_repository_impl.dart';
import '../../../../domain/entities/community_post.dart';
import '../../../../domain/entities/recipe.dart';
import '../../../../domain/usecases/community/get_community_posts_usecase.dart';
import '../../../../domain/usecases/community/get_recipes_usecase.dart';
import '../../../../domain/usecases/community/toggle_post_like_usecase.dart';
import '../../../../domain/usecases/community/create_post_usecase.dart';
import '../../../../domain/usecases/community/edit_post_usecase.dart';
import '../../../../domain/usecases/community/delete_post_usecase.dart';
import '../../../../domain/usecases/community/get_post_comments_usecase.dart';
import '../../../../domain/usecases/community/create_comment_usecase.dart';
import '../../../../domain/usecases/community/toggle_comment_like_usecase.dart';

// Remote Data source provider
final communityRemoteDataSourceProvider = Provider<CommunityRemoteDataSource>((ref) {
  return CommunityRemoteDataSourceImpl(ref.watch(dioProvider));
});

// Local Data source provider
final communityLocalDataSourceProvider = Provider<CommunityLocalDataSource>((ref) {
  return CommunityLocalDataSourceImpl(sharedPreferences: ref.watch(sharedPreferencesProvider));
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

final getRecipesUseCaseProvider = Provider<GetRecipesUseCase>((ref) {
  return GetRecipesUseCase(ref.watch(communityRepositoryProvider));
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

// Example State providers
final communityPostsProvider = FutureProvider.family<List<CommunityPost>, String>((ref, filter) async {
  final useCase = ref.watch(getCommunityPostsUseCaseProvider);
  final result = await useCase(page: 1, limit: 10, filter: filter);

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (posts) => posts.data,
  );
});

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final useCase = ref.watch(getRecipesUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (recipes) => recipes,
  );
});

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure _:
      return 'Server error occurred';
    case CacheFailure _:
      return 'Cache error occurred';
    case NetworkFailure _:
      return 'Network error occurred';
    default:
      return 'Unexpected error occurred';
  }
}
