import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<Recipe>>> call({
    int page = 1,
    int limit = 20,
    String? search,
    String? authorId,
    String? difficulty,
    bool? isFeatured,
  }) async {
    return await repository.getRecipes(
      page: page,
      limit: limit,
      search: search,
      authorId: authorId,
      difficulty: difficulty,
      isFeatured: isFeatured,
    );
  }
}
