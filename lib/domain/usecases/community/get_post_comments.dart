import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/post_comment.dart';
import '../../repositories/community_repository.dart';

class GetPostComments {
  final CommunityRepository repository;

  GetPostComments(this.repository);

  Future<Either<Failure, List<PostComment>>> call(String postId) {
    return repository.getPostComments(postId);
  }
}
