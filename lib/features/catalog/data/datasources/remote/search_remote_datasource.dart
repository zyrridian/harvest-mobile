import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/product_model.dart';
import 'package:harvest_app/data/models/farmer_model.dart';
import 'package:harvest_app/features/catalog/data/models/search_history_model.dart';
import 'package:harvest_app/features/catalog/data/models/search_suggestion_model.dart';

abstract class SearchRemoteDataSource {
  /// Search products from API
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  });

  /// Search farmers from API
  Future<List<FarmerModel>> searchFarmers({
    required String query,
    String? specialties,
    double? minRating,
    int? page,
    int? limit,
  });

  /// Get search history
  Future<List<SearchHistoryModel>> getSearchHistory({int? limit});

  /// Delete a single search history item
  Future<void> deleteSearchHistory(String id);

  /// Clear all search history
  Future<void> clearSearchHistory();

  /// Get search suggestions
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    required String query,
    String? type,
    int? limit,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (sortBy != null) 'sort_by': sortBy,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (categories != null && categories.isNotEmpty)
          'categories': categories.join(','),
        if (types != null && types.isNotEmpty) 'types': types.join(','),
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      final response = await dio.get('/catalog/search/products',
          queryParameters: queryParams);

      final List<dynamic> data = response.data['data'];
      return data.map<ProductModel>((dynamic item) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(item as Map);
        // Normalize fields from catalog API to match ProductModel
        json['farmer_name'] ??= json['store_name'];
        json['farmer_id'] ??= json['store_id'];
        if (json['tags'] == null && json['tag'] != null) {
          json['tags'] = [json['tag']];
        }
        json['tags'] ??= [];
        json['review_count'] ??= 0;
        json['rating'] = (json['rating'] as num?)?.toDouble() ?? 0.0;
        json['price'] = (json['price'] as num?)?.toDouble() ?? 0.0;
        json['is_organic'] ??= false;
        json['is_available'] ??= true;
        json['images'] ??= [];
        return ProductModel.fromJson(json);
      }).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<FarmerModel>> searchFarmers({
    required String query,
    String? specialties,
    double? minRating,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (specialties != null) 'specialties': specialties,
        if (minRating != null) 'min_rating': minRating,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };

      final response = await dio.get('/catalog/search/farmers',
          queryParameters: queryParams);

      final List<dynamic> data = response.data['data'];
      return data.map<FarmerModel>((json) => FarmerModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<SearchHistoryModel>> getSearchHistory({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{
        if (limit != null) 'limit': limit,
      };

      final response = await dio.get('/catalog/search/history',
          queryParameters: queryParams);

      final List<dynamic> data = response.data['data'];
      return data.map<SearchHistoryModel>((json) => SearchHistoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> deleteSearchHistory(String id) async {
    try {
      await dio.delete('/catalog/search/history/$id');
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await dio.delete('/catalog/search/history');
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    required String query,
    String? type,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (type != null) 'type': type,
        if (limit != null) 'limit': limit,
      };

      final response = await dio.get('/catalog/search/suggestions',
          queryParameters: queryParams);

      final List<dynamic> data = response.data['data'];
      return data.map<SearchSuggestionModel>((json) => SearchSuggestionModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }
}
