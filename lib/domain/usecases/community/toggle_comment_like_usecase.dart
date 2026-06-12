import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/community_repository.dart';

class ToggleCommentLikeUseCase {
  final CommunityRepository repository;

  ToggleCommentLikeUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String commentId,
    required bool isCurrentlyLiked,
  }) {
    // API currently only has a generic likeComment endpoint or we assume it toggles, but wait, the API guide only has /comments/:id/like
    // Let's just call likeComment for now as per the user's guide.
    return repository.likeComment(commentId);
  }
}
