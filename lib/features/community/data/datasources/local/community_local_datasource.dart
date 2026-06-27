import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../data/models/community_post_model.dart';
import '../../../../../data/models/recipe_model.dart';
import '../../../../../data/models/paginated_response_model.dart';

abstract class CommunityLocalDataSource {
  Future<void> saveCommunityPosts(String cacheKey, PaginatedResponseModel<CommunityPostModel> posts);
  Future<PaginatedResponseModel<CommunityPostModel>?> getCommunityPosts(String cacheKey);
  
  Future<void> saveRecipes(List<RecipeModel> recipes);
  Future<List<RecipeModel>?> getRecipes();
}

class CommunityLocalDataSourceImpl implements CommunityLocalDataSource {
  final SharedPreferences sharedPreferences;

  CommunityLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<PaginatedResponseModel<CommunityPostModel>?> getCommunityPosts(String cacheKey) async {
    try {
      final jsonStr = sharedPreferences.getString(cacheKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        return PaginatedResponseModel.fromJson(
          decoded,
          (json) => CommunityPostModel.fromJson(json),
        );
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached community posts: $e');
    }
  }

  @override
  Future<void> saveCommunityPosts(String cacheKey, PaginatedResponseModel<CommunityPostModel> posts) async {
    try {
      // Create a map to cache
      final jsonMap = {
        'status': posts.status,
        'data': {
          'posts': posts.data.map((e) => e.toJson()).toList(),
          'pagination': posts.pagination?.toJson(),
        }
      };
      await sharedPreferences.setString(cacheKey, jsonEncode(jsonMap));
    } catch (e) {
      throw CacheException('Failed to save community posts: $e');
    }
  }

  @override
  Future<List<RecipeModel>?> getRecipes() async {
    try {
      final jsonStr = sharedPreferences.getString('CACHED_RECIPES');
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as List;
        return decoded.map((e) => RecipeModel.fromJson(e)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached recipes: $e');
    }
  }

  @override
  Future<void> saveRecipes(List<RecipeModel> recipes) async {
    try {
      final jsonList = recipes.map((e) => e.toJson()).toList();
      await sharedPreferences.setString('CACHED_RECIPES', jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Failed to save recipes: $e');
    }
  }
}
