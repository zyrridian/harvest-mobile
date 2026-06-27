import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository repository;

  GetAllCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    try {
      final categories = await repository.getAllCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
