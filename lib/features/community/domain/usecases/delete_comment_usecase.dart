import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repository.dart';
import '../../presentation/providers/community_controller.dart';

final deleteCommentUseCaseProvider = Provider<DeleteCommentUseCase>((ref) {
  return DeleteCommentUseCase(ref.watch(communityRepositoryProvider));
});

class DeleteCommentUseCase {
  final CommunityRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String commentId,
  }) {
    return repository.deleteComment(commentId);
  }
}
