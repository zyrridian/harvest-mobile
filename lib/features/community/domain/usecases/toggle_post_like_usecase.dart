import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repository.dart';

class TogglePostLikeUseCase {
  final CommunityRepository repository;

  TogglePostLikeUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String postId,
    required bool isCurrentlyLiked,
  }) async {
    if (isCurrentlyLiked) {
      return await repository.unlikePost(postId);
    } else {
      return await repository.likePost(postId);
    }
  }
}
