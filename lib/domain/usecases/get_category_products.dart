import 'package:harvest_app/domain/entities/category_product.dart';
import 'package:harvest_app/domain/repositories/category_repository.dart';

class GetCategoryProducts {
  final CategoryRepository repository;

  GetCategoryProducts(this.repository);

  Future<List<CategoryProduct>> call(String categoryId) async {
    return await repository.getCategoryProducts(categoryId);
  }
}
