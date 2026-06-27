import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/features/catalog/data/models/category_model.dart';
import 'package:harvest_app/features/catalog/data/models/category_product_model.dart';
import 'package:harvest_app/features/catalog/data/models/category_response_model.dart';
import 'package:dio/dio.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<CategoryProductModel>> getCategoryProducts(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio _dio;

  CategoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _dio.get(AppConstants.catalogCategoriesEndpoint);
      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = CategoryListResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw Exception('Failed to fetch categories: API returned unsuccessful status');
        }
      } else {
        throw Exception('Failed to fetch categories: Invalid response');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await _dio.get(AppConstants.catalogCategoryByIdEndpoint
          .replaceFirst(':id', categoryId));
      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = CategoryDetailResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!;
        } else {
          throw Exception('Failed to fetch category: API returned unsuccessful status');
        }
      } else {
        throw Exception('Failed to fetch category: Invalid response');
      }
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  @override
  Future<List<CategoryProductModel>> getCategoryProducts(
      String categoryId) async {
    try {
      final response = await _dio.get(AppConstants
          .catalogCategoryProductsEndpoint
          .replaceFirst(':id', categoryId));
      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = CategoryProductsResponse.fromJson(response.data);
        if (apiResponse.isSuccess && apiResponse.data != null) {
          return apiResponse.data!.products;
        } else {
          throw Exception('Failed to fetch category products: API returned unsuccessful status');
        }
      } else {
        throw Exception('Failed to fetch category products: Invalid response');
      }
    } catch (e) {
      throw Exception('Failed to fetch category products: $e');
    }
  }
}
