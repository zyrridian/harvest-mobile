import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/community/data/datasources/local/recipe_local_datasource.dart';
import 'package:harvest_app/features/community/data/datasources/remote/recipe_remote_datasource.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PaginatedResponse<Recipe>>> getRecipes({
    int page = 1,
    int limit = 20,
    String? search,
    String? authorId,
    String? difficulty,
    bool? isFeatured,
  }) async {
    try {
      final remoteRecipes = await remoteDataSource.getRecipes(
        page: page,
        limit: limit,
        search: search,
        authorId: authorId,
        difficulty: difficulty,
        isFeatured: isFeatured,
      );

      // Cache the first page assuming it's the most relevant for offline
      if (page == 1) {
        await localDataSource.saveRecipes(remoteRecipes);
      }

      return Right(remoteRecipes.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (page == 1) {
        try {
          final localRecipes = await localDataSource.getRecipes();
          if (localRecipes != null) {
            return Right(localRecipes.toEntity((model) => model.toEntity()));
          }
        } catch (_) {}
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(String id) async {
    try {
      final remoteRecipe = await remoteDataSource.getRecipeById(id);
      return Right(remoteRecipe.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Recipe>> createRecipe(Map<String, dynamic> data) async {
    try {
      final remoteRecipe = await remoteDataSource.createRecipe(data);
      return Right(remoteRecipe.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Recipe>> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      final remoteRecipe = await remoteDataSource.updateRecipe(id, data);
      return Right(remoteRecipe.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipe(String id) async {
    try {
      await remoteDataSource.deleteRecipe(id);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
