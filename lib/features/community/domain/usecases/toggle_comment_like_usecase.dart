import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repository.dart';

class ToggleCommentLikeUseCase {
  final CommunityRepository repository;

  ToggleCommentLikeUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String commentId,
    required bool isCurrentlyLiked,
  }) {
    if (isCurrentlyLiked) {
      return repository.unlikeComment(commentId);
    } else {
      return repository.likeComment(commentId);
    }
  }
}
