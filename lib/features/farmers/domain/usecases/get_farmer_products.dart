import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../../core/models/paginated_response.dart';
import '../repositories/farmer_products_repository.dart';

class GetFarmerProducts {
  final FarmerProductsRepository repository;

  GetFarmerProducts(this.repository);

  Future<Either<Failure, PaginatedResponse<Product>>> call(
    String farmerId, {
    int? limit,
    int? page,
  }) async {
    return await repository.getFarmerProducts(
      farmerId,
      limit: limit,
      page: page,
    );
  }
}
