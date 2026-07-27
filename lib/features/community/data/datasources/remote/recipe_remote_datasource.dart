import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/community/data/models/recipe_model.dart';
import 'package:harvest_app/core/models/paginated_response_model.dart';

abstract class RecipeRemoteDataSource {
  Future<PaginatedResponseModel<RecipeModel>> getRecipes({
    int page = 1,
    int limit = 20,
    String? search,
    String? authorId,
    String? difficulty,
    bool? isFeatured,
  });

  Future<RecipeModel> getRecipeById(String id);

  Future<RecipeModel> createRecipe(Map<String, dynamic> data);

  Future<RecipeModel> updateRecipe(String id, Map<String, dynamic> data);

  Future<void> deleteRecipe(String id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedResponseModel<RecipeModel>> getRecipes({
    int page = 1,
    int limit = 20,
    String? search,
    String? authorId,
    String? difficulty,
    bool? isFeatured,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (search != null) queryParams['search'] = search;
      if (authorId != null) queryParams['author_id'] = authorId;
      if (difficulty != null) queryParams['difficulty'] = difficulty;
      if (isFeatured != null) queryParams['is_featured'] = isFeatured;

      final response = await dio.get(
        '/community/recipes',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => RecipeModel.fromJson(json),
        );
      } else {
        throw ServerException(
          'Failed to fetch recipes',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<RecipeModel> getRecipeById(String id) async {
    try {
      final response = await dio.get('/community/recipes/$id');

      if (response.statusCode == 200) {
        return RecipeModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          'Failed to fetch recipe',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<RecipeModel> createRecipe(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/community/recipes', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RecipeModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          'Failed to create recipe',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<RecipeModel> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/community/recipes/$id', data: data);

      if (response.statusCode == 200) {
        return RecipeModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          'Failed to update recipe',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      final response = await dio.delete('/community/recipes/$id');

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to delete recipe',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Server error occurred';
        throw ServerException(message, statusCode: statusCode);
      case DioExceptionType.cancel:
        throw ServerException('Request cancelled');
      case DioExceptionType.unknown:
        throw NetworkException('No internet connection');
      default:
        throw ServerException('An unexpected error occurred');
    }
  }
}
