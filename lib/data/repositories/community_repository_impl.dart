import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/post_comment.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/remote/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CommunityPost>>> getFarmerPosts(
      String farmerId) async {
    try {
      final models = await remoteDataSource.getFarmerPosts(farmerId);
      final posts = models.map((model) => model.toEntity()).toList();
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostComment>>> getPostComments(
      String postId) async {
    try {
      final models = await remoteDataSource.getPostComments(postId);
      final comments = models.map((model) => model.toEntity()).toList();
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
