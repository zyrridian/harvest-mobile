import 'package:harvest_app/features/catalog/data/datasources/remote/category_remote_datasource.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Category>> getAllCategories() async {
    final models = await remoteDataSource.getAllCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Category> getCategoryById(String categoryId) async {
    final model = await remoteDataSource.getCategoryById(categoryId);
    return model.toEntity();
  }

  @override
  Future<List<CategoryProduct>> getCategoryProducts(String categoryId) async {
    final models = await remoteDataSource.getCategoryProducts(categoryId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CategoryProduct>> searchProductsInCategory(
    String categoryId,
    String query,
  ) async {
    final products = await getCategoryProducts(categoryId);
    return products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
