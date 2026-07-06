import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/community_repository.dart';

class DeletePostUseCase {
  final CommunityRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call({required String postId}) {
    return repository.deletePost(postId);
  }
}
