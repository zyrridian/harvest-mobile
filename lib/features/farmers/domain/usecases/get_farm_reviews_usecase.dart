import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farm_review.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class GetFarmReviewsUseCase {
  final ProducerRepository repository;

  GetFarmReviewsUseCase(this.repository);

  Future<Either<Failure, FarmReviewResponse>> execute({int page = 1, int limit = 20}) {
    return repository.getReviews(page: page, limit: limit);
  }
}
