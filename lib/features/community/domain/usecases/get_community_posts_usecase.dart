import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/community_post.dart';
import '../../../../core/models/paginated_response.dart';
import '../repositories/community_repository.dart';

class GetCommunityPostsUseCase {
  final CommunityRepository repository;

  GetCommunityPostsUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<CommunityPost>>> call({
    required int page,
    required int limit,
    required String filter,
    String? tag,
  }) async {
    return await repository.getCommunityPosts(
      page: page,
      limit: limit,
      filter: filter,
      tag: tag,
    );
  }
}
