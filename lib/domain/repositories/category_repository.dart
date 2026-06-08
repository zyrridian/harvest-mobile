import 'package:harvest_app/domain/entities/category.dart';
import 'package:harvest_app/domain/entities/category_product.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category> getCategoryById(String categoryId);
  Future<List<CategoryProduct>> getCategoryProducts(String categoryId);
  Future<List<CategoryProduct>> searchProductsInCategory(
    String categoryId,
    String query,
  );
}
