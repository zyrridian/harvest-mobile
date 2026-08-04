import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/paginated_response.dart';
import '../entities/community_comment.dart';
import '../repositories/community_repository.dart';

class GetPostCommentsUseCase {
  final CommunityRepository repository;

  GetPostCommentsUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<CommunityComment>>> call({
    required String postId,
    int page = 1,
    int limit = 50,
  }) {
    return repository.getPostComments(
      postId: postId,
      page: page,
      limit: limit,
    );
  }
}
