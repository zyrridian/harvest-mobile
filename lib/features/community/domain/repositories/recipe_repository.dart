import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Future<Either<Failure, PaginatedResponse<Recipe>>> getRecipes({
    int page = 1,
    int limit = 20,
    String? search,
    String? authorId,
    String? difficulty,
    bool? isFeatured,
  });

  Future<Either<Failure, Recipe>> getRecipeById(String id);

  Future<Either<Failure, Recipe>> createRecipe(Map<String, dynamic> data);

  Future<Either<Failure, Recipe>> updateRecipe(String id, Map<String, dynamic> data);

  Future<Either<Failure, void>> deleteRecipe(String id);
}
