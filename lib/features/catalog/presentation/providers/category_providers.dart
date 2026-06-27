import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/catalog/data/datasources/remote/category_remote_datasource.dart';
import 'package:harvest_app/features/catalog/data/repositories/category_repository_impl.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';
import 'package:harvest_app/features/catalog/domain/usecases/get_all_categories.dart';
import 'package:harvest_app/features/catalog/domain/usecases/get_category_products.dart';

import 'package:harvest_app/core/providers/dio_provider.dart';

// Data Source Provider
final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl(ref.read(dioProvider));
});

// Repository Provider
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    ref.read(categoryRemoteDataSourceProvider),
  );
});

// Use Cases Providers
final getAllCategoriesUseCaseProvider = Provider<GetAllCategories>((ref) {
  return GetAllCategories(ref.read(categoryRepositoryProvider));
});

final getCategoryProductsUseCaseProvider = Provider<GetCategoryProducts>((ref) {
  return GetCategoryProducts(ref.read(categoryRepositoryProvider));
});

// State Providers
final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final useCase = ref.read(getAllCategoriesUseCaseProvider);
  return await useCase();
});

final categoryProductsProvider =
    FutureProvider.family<List<CategoryProduct>, String>(
        (ref, categoryId) async {
  final useCase = ref.read(getCategoryProductsUseCaseProvider);
  return await useCase(categoryId);
});

// Sort options
enum ProductSortOption {
  popular,
  priceLowToHigh,
  priceHighToLow,
  nameAZ,
  rating,
}

final selectedSortOptionProvider =
    StateProvider<ProductSortOption>((ref) => ProductSortOption.popular);

// Filter providers
final showOnlyOrganicProvider = StateProvider<bool>((ref) => false);
final showOnlyPremiumProvider = StateProvider<bool>((ref) => false);
