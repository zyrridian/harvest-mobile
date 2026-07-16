import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../community/domain/entities/review.dart';
import '../../../../domain/entities/paginated_response.dart';

abstract class FarmerProductsRepository {
  Future<Either<Failure, PaginatedResponse<Product>>> getFarmerProducts(String farmerId, {int? limit, int? page});
  Future<Either<Failure, PaginatedResponse<Review>>> getFarmerReviews(String farmerId, {int? limit, int? page});
}
