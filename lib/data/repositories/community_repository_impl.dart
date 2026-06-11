import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/post_comment.dart';
import '../../domain/entities/paginated_response.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/remote/community_remote_datasource.dart';
import '../../core/error/exceptions.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<CommunityPost>>> getFarmerPosts(String farmerId, {int? limit, int? page}) async {
    try {
      final response = await remoteDataSource.getFarmerPosts(farmerId, limit: limit, page: page);
      return Right(response.toEntity((model) => model.toEntity()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
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
