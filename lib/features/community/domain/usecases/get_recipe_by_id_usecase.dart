import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/domain/repositories/recipe_repository.dart';

class GetRecipeByIdUseCase {
  final RecipeRepository repository;

  GetRecipeByIdUseCase(this.repository);

  Future<Either<Failure, Recipe>> call(String id) async {
    return await repository.getRecipeById(id);
  }
}
