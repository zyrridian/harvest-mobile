import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_list_response.dart';
import 'package:harvest_app/features/catalog/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, ProductListResponse>> call({
    int? page,
    int? limit,
    String? category,
    String? sellerId,
    bool? isOrganic,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) {
    return repository.getProducts(
      page: page,
      limit: limit,
      category: category,
      sellerId: sellerId,
      isOrganic: isOrganic,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
      order: order,
    );
  }
}
