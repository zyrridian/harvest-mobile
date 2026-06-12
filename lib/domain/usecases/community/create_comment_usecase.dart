import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/community_comment.dart';
import '../../repositories/community_repository.dart';

class CreateCommentUseCase {
  final CommunityRepository repository;

  CreateCommentUseCase(this.repository);

  Future<Either<Failure, CommunityComment>> call({
    required String postId,
    required String content,
    String? parentId,
    String? replyToUserId,
  }) {
    return repository.createComment(
      postId: postId,
      content: content,
      parentId: parentId,
      replyToUserId: replyToUserId,
    );
  }
}
