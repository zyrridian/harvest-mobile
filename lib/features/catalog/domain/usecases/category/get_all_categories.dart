import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getAllCategories();
  }
}
