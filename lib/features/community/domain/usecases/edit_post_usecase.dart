import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/community_post.dart';
import '../repositories/community_repository.dart';

class EditPostUseCase {
  final CommunityRepository repository;

  EditPostUseCase(this.repository);

  Future<Either<Failure, CommunityPost>> call({
    required String postId,
    required String title,
    required String content,
  }) {
    return repository.editPost(
      postId: postId,
      title: title,
      content: content,
    );
  }
}
