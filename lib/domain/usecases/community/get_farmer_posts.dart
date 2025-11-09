import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/community_post.dart';
import '../../repositories/community_repository.dart';

class GetFarmerPosts {
  final CommunityRepository repository;

  GetFarmerPosts(this.repository);

  Future<Either<Failure, List<CommunityPost>>> call(String farmerId) {
    return repository.getFarmerPosts(farmerId);
  }
}
