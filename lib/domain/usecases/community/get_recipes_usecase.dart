import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/recipe.dart';
import '../../repositories/community_repository.dart';

class GetRecipesUseCase {
  final CommunityRepository repository;

  GetRecipesUseCase(this.repository);

  Future<Either<Failure, List<Recipe>>> call() async {
    return await repository.getRecipes();
  }
}
