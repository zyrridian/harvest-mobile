import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/community_post.dart';
import '../../entities/paginated_response.dart';
import '../../repositories/community_repository.dart';

class GetFarmerPosts {
  final CommunityRepository repository;

  GetFarmerPosts(this.repository);

  Future<Either<Failure, PaginatedResponse<CommunityPost>>> call(
    String farmerId, {
    int? limit,
    int? page,
  }) async {
    return await repository.getFarmerPosts(
      farmerId,
      limit: limit,
      page: page,
    );
  }
}
