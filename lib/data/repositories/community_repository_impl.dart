import 'package:dartz/dartz.dart';
import 'package:harvest_app/domain/entities/community_comment.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures\.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/paginated_response.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/local/community_local_datasource.dart';
import '../datasources/remote/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;
  final CommunityLocalDataSource localDataSource;

  CommunityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PaginatedResponse<CommunityPost>>> getCommunityPosts({
    required int page,
    required int limit,
    required String filter,
    String? tag,
  }) async {
    final cacheKey =
        'COMMUNITY_POSTS_\${filter}_\${tag ?? ' '}_\${page}_\${limit}';
    try {
      final remotePosts = await remoteDataSource.getCommunityPosts(
        page: page,
        limit: limit,
        filter: filter,
        tag: tag,
      );

      // Save to local cache on success (mostly for page 1)
      if (page == 1) {
        await localDataSource.saveCommunityPosts(cacheKey, remotePosts);
      }

      return Right(remotePosts.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (page == 1) {
        try {
          final localPosts = await localDataSource.getCommunityPosts(cacheKey);
          if (localPosts != null) {
            return Right(localPosts.toEntity((model) => model.toEntity()));
          }
        } catch (_) {
          // Ignore local cache error, fallback to returning the actual error below
        }
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes() async {
    try {
      final remoteRecipes = await remoteDataSource.getRecipes();

      await localDataSource.saveRecipes(remoteRecipes);

      return Right(remoteRecipes.map((e) => e.toEntity()).toList());
    } catch (e) {
      try {
        final localRecipes = await localDataSource.getRecipes();
        if (localRecipes != null) {
          return Right(localRecipes.map((e) => e.toEntity()).toList());
        }
      } catch (_) {}

      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      await remoteDataSource.likePost(postId);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    try {
      await remoteDataSource.unlikePost(postId);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, CommunityPost>> createPost({
    required String title,
    required String content,
    List<String> images = const [],
    List<String> tags = const [],
  }) async {
    try {
      final remotePost = await remoteDataSource.createPost(
        title: title,
        content: content,
        images: images,
        tags: tags,
      );
      return Right(remotePost.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, CommunityPost>> editPost({
    required String postId,
    required String title,
    required String content,
  }) async {
    try {
      final remotePost = await remoteDataSource.editPost(
        postId: postId,
        title: title,
        content: content,
      );
      return Right(remotePost.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<CommunityComment>>> getPostComments({
    required String postId,
    required int page,
    required int limit,
  }) async {
    try {
      final remoteComments = await remoteDataSource.getPostComments(
        postId: postId,
        page: page,
        limit: limit,
      );
      return Right(remoteComments.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, CommunityComment>> createComment({
    required String postId,
    required String content,
    String? parentId,
    String? replyToUserId,
  }) async {
    try {
      final remoteComment = await remoteDataSource.createComment(
        postId: postId,
        content: content,
        parentId: parentId,
        replyToUserId: replyToUserId,
      );
      return Right(remoteComment.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(String commentId) async {
    try {
      await remoteDataSource.likeComment(commentId);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(ServerFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
