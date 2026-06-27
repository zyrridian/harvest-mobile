import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/catalog/domain/entities/search_history.dart';
import 'package:harvest_app/features/catalog/domain/repositories/search_repository.dart';

class GetRecentSearches {
  final SearchRepository repository;

  GetRecentSearches(this.repository);

  Future<Either<Failure, List<SearchHistory>>> call({int? limit}) async {
    return await repository.getRecentSearches(limit: limit);
  }
}
