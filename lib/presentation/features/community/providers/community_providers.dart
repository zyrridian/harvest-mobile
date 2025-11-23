import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/remote/community_remote_datasource.dart';
import '../../../../data/repositories/community_repository_impl.dart';
import '../../../../domain/entities/community_post.dart';
import '../../../../domain/entities/post_comment.dart';
import '../../../../domain/usecases/community/get_farmer_posts.dart';
import '../../../../domain/usecases/community/get_post_comments.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Data source provider
final communityDataSourceProvider = Provider<CommunityRemoteDataSource>((ref) {
  return CommunityRemoteDataSourceImpl(ref.watch(dioProvider));
});

// Repository provider
final communityRepositoryProvider = Provider<CommunityRepositoryImpl>((ref) {
  return CommunityRepositoryImpl(ref.watch(communityDataSourceProvider));
});

// Use cases providers
final getFarmerPostsUseCaseProvider = Provider<GetFarmerPosts>((ref) {
  return GetFarmerPosts(ref.watch(communityRepositoryProvider));
});

final getPostCommentsUseCaseProvider = Provider<GetPostComments>((ref) {
  return GetPostComments(ref.watch(communityRepositoryProvider));
});

// State providers
final farmerPostsProvider =
    FutureProvider.family<List<CommunityPost>, String>((ref, farmerId) async {
  final useCase = ref.watch(getFarmerPostsUseCaseProvider);
  final result = await useCase(farmerId);

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (posts) => posts,
  );
});

final postCommentsProvider =
    FutureProvider.family<List<PostComment>, String>((ref, postId) async {
  final useCase = ref.watch(getPostCommentsUseCaseProvider);
  final result = await useCase(postId);

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (comments) => comments,
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
