import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/product.dart';
import '../../repositories/search_repository.dart';

class SearchProducts {
  final SearchRepository repository;

  SearchProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  }) async {
    return await repository.searchProducts(
      query: query,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      categories: categories,
      types: types,
      page: page,
      limit: limit,
    );
  }
}
