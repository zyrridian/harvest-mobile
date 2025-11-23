import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/review.dart';

abstract class FarmerProductsRepository {
  Future<Either<Failure, List<Product>>> getFarmerProducts(String farmerId);
  Future<Either<Failure, List<Review>>> getFarmerReviews(String farmerId);
}
