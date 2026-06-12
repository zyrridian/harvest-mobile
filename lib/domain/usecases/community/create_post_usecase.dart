import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/community_post.dart';
import '../../repositories/community_repository.dart';

class CreatePostUseCase {
  final CommunityRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, CommunityPost>> call({
    required String title,
    required String content,
    List<String> images = const [],
    List<String> tags = const [],
  }) {
    return repository.createPost(
      title: title,
      content: content,
      images: images,
      tags: tags,
    );
  }
}
