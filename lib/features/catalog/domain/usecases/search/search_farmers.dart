import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/catalog/domain/repositories/search_repository.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';

class SearchFarmers {
  final SearchRepository repository;

  SearchFarmers(this.repository);

  Future<Either<Failure, List<Farmer>>> call({
    required String query,
    String? specialties,
    double? minRating,
    int? page,
    int? limit,
  }) async {
    return await repository.searchFarmers(
      query: query,
      specialties: specialties,
      minRating: minRating,
      page: page,
      limit: limit,
    );
  }
}
