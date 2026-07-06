import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../features/community/domain/entities/review.dart';
import '../../entities/paginated_response.dart';
import '../../repositories/farmer_products_repository.dart';

class GetFarmerReviews {
  final FarmerProductsRepository repository;

  GetFarmerReviews(this.repository);

  Future<Either<Failure, PaginatedResponse<Review>>> call(
    String farmerId, {
    int? limit,
    int? page,
  }) async {
    return await repository.getFarmerReviews(
      farmerId,
      limit: limit,
      page: page,
    );
  }
}
