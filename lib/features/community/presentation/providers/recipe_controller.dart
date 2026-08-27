import 'package:harvest_app/core/models/paginated_response.dart';
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
import 'package:harvest_app/features/community/presentation/screens/community_screen.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'recipe_state.dart';

part 'recipe_controller.g.dart';

@riverpod
class RecipeController extends _$RecipeController {
  String? _currentAuthorId;
  int _activeRequestId = 0;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  RecipeState build() {
    final tab = ref.watch(communityTabProvider);

    if (tab == 'My Recipes') {
      final authState = ref.watch(authControllerProvider);
      _currentAuthorId = authState.maybeWhen(
        authenticated: (user) => user.id,
        orElse: () => null,
      );
    } else {
      _currentAuthorId = null;
    }

    // Schedule fetch to avoid state modification during build phase (although safe for this controller, Future.microtask is cleaner for triggering side-effects from build)
    Future.microtask(() => _fetchRecipes());
    return const RecipeState.loading();
  }

  Future<void> _fetchRecipes({int page = 1}) async {
    final requestId = ++_activeRequestId;
    if (page == 1) {
      state = const RecipeState.loading();
      _currentPage = 1;
    } else {
      _isLoadingMore = true;
    }
    final useCase = ref.read(getRecipesUseCaseProvider);
    final result = await useCase.call(
      page: page,
      limit: 20,
      authorId: _currentAuthorId,
    );

    if (requestId != _activeRequestId) return;

    result.fold(
      (failure) {
        if (page == 1) {
          state = RecipeState.error(failure.message);
        }
        _isLoadingMore = false;
      },
      (data) {
        if (page == 1) {
          state = RecipeState.data(data);
        } else {
          state.maybeWhen(
            data: (oldData) {
              final newItems = [...oldData.data, ...data.data];
              state = RecipeState.data(PaginatedResponse(
                data: newItems,
                pagination: data.pagination,
              ));
            },
            orElse: () => state = RecipeState.data(data),
          );
        }
        _currentPage = page;
        _isLoadingMore = false;
      },
    );
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore) return;

    state.maybeWhen(
      data: (data) {
        if (data.pagination.currentPage < data.pagination.totalPages) {
          _fetchRecipes(page: _currentPage + 1);
        }
      },
      orElse: () {},
    );
  }

  void refresh({String? authorId, bool keepAuthor = false}) {
    if (!keepAuthor) {
      _currentAuthorId = authorId;
    }
    _fetchRecipes();
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
            final updatedRecipes =
                data.data.where((recipe) => recipe.id != id).toList();
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
  return RecipeLocalDataSourceImpl(
      sharedPreferences: ref.watch(sharedPreferencesProvider));
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
