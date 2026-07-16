import 'dart:convert';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/community/data/models/recipe_model.dart';
import 'package:harvest_app/core/models/paginated_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecipeLocalDataSource {
  Future<void> saveRecipes(PaginatedResponseModel<RecipeModel> recipes);
  Future<PaginatedResponseModel<RecipeModel>?> getRecipes();
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedCommunityRecipesKey = 'CACHED_COMMUNITY_RECIPES';

  RecipeLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<PaginatedResponseModel<RecipeModel>?> getRecipes() async {
    try {
      final recipesJson = sharedPreferences.getString(cachedCommunityRecipesKey);
      if (recipesJson != null) {
        final decoded = jsonDecode(recipesJson) as Map<String, dynamic>;
        return PaginatedResponseModel.fromJson(
          decoded,
          (json) => RecipeModel.fromJson(json),
        );
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached recipes: $e');
    }
  }

  @override
  Future<void> saveRecipes(PaginatedResponseModel<RecipeModel> recipes) async {
    try {
      final jsonMap = {
        'status': recipes.status,
        'data': {
          'recipes': recipes.data.map((e) => e.toJson()).toList(),
          'pagination': recipes.pagination?.toJson(),
        }
      };
      await sharedPreferences.setString(
        cachedCommunityRecipesKey,
        jsonEncode(jsonMap),
      );
    } catch (e) {
      throw CacheException('Failed to save recipes: $e');
    }
  }
}
