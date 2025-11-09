import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/review.dart';
import '../../repositories/farmer_products_repository.dart';

class GetFarmerReviews {
  final FarmerProductsRepository repository;

  GetFarmerReviews(this.repository);

  Future<Either<Failure, List<Review>>> call(String farmerId) async {
    return await repository.getFarmerReviews(farmerId);
  }
}
