import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/domain/repositories/recipe_repository.dart';

class CreateRecipeUseCase {
  final RecipeRepository repository;

  CreateRecipeUseCase(this.repository);

  Future<Either<Failure, Recipe>> call(Map<String, dynamic> data) async {
    return await repository.createRecipe(data);
  }
}
