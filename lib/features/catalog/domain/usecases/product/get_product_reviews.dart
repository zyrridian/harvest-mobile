import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../community/domain/entities/review_response.dart';
import '../../repositories/product_repository.dart';

class GetProductReviews {
  final ProductRepository repository;

  GetProductReviews(this.repository);

  Future<Either<Failure, ReviewResponse>> call(String slug, {int limit = 5}) async {
    return await repository.getProductReviews(slug, limit: limit);
  }
}
