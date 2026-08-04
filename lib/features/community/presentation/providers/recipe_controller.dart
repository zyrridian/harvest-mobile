import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/features/community/data/datasources/remote/recipe_remote_datasource.dart';
import 'package:harvest_app/features/community/data/datasources/local/recipe_local_datasource.dart';
import 'package:harvest_app/features/community/data/repositories/recipe_repository_impl.dart';
import 'package:harvest_app/features/community/domain/usecases/get_recipes_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/create_recipe_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/get_recipe_by_id_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/update_recipe_usecase.dart';
import 'package:harvest_app/features/community/domain/usecases/delete_recipe_usecase.dart';
import 'recipe_state.dart';

part 'recipe_controller.g.dart';

@riverpod
class RecipeController extends _$RecipeController {
  @override
  RecipeState build() {
    _fetchRecipes();
    return const RecipeState.loading();
  }

  Future<void> _fetchRecipes({int page = 1, String? authorId}) async {
    state = const RecipeState.loading();
    final useCase = ref.read(getRecipesUseCaseProvider);
    final result = await useCase.call(
      page: page,
      limit: 20,
      authorId: authorId,
    );

    result.fold(
      (failure) => state = RecipeState.error(failure.message),
      (data) => state = RecipeState.data(data),
    );
  }

  void refresh({String? authorId}) {
    _fetchRecipes(authorId: authorId);
  }

  Future<void> deleteRecipe(String id) async {
    final useCase = ref.read(deleteRecipeUseCaseProvider);
    final result = await useCase.call(id);
    
    result.fold(
      (failure) {
        // Handle failure if needed
      },
      (_) {
        state.maybeWhen(
          data: (data) {
            final updatedRecipes = data.data.where((recipe) => recipe.id != id).toList();
            state = RecipeState.data(data.copyWith(data: updatedRecipes));
          },
          orElse: () => refresh(),
        );
      },
    );
  }
}

// Recipe Data source providers
final recipeRemoteDataSourceProvider = Provider<RecipeRemoteDataSource>((ref) {
  return RecipeRemoteDataSourceImpl(ref.watch(dioProvider));
});

final recipeLocalDataSourceProvider = Provider<RecipeLocalDataSource>((ref) {
  return RecipeLocalDataSourceImpl(sharedPreferences: ref.watch(sharedPreferencesProvider));
});

// Recipe Repository provider
final recipeRepositoryProvider = Provider<RecipeRepositoryImpl>((ref) {
  return RecipeRepositoryImpl(
    remoteDataSource: ref.watch(recipeRemoteDataSourceProvider),
    localDataSource: ref.watch(recipeLocalDataSourceProvider),
  );
});

// Recipe Use cases providers
final getRecipesUseCaseProvider = Provider<GetRecipesUseCase>((ref) {
  return GetRecipesUseCase(ref.watch(recipeRepositoryProvider));
});

final createRecipeUseCaseProvider = Provider<CreateRecipeUseCase>((ref) {
  return CreateRecipeUseCase(ref.watch(recipeRepositoryProvider));
});

final getRecipeByIdUseCaseProvider = Provider<GetRecipeByIdUseCase>((ref) {
  return GetRecipeByIdUseCase(ref.watch(recipeRepositoryProvider));
});

final updateRecipeUseCaseProvider = Provider<UpdateRecipeUseCase>((ref) {
  return UpdateRecipeUseCase(ref.watch(recipeRepositoryProvider));
});

final deleteRecipeUseCaseProvider = Provider<DeleteRecipeUseCase>((ref) {
  return DeleteRecipeUseCase(ref.watch(recipeRepositoryProvider));
});
