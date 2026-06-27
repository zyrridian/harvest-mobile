import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/catalog/domain/entities/search_suggestion.dart';
import 'package:harvest_app/features/catalog/domain/repositories/search_repository.dart';

class GetSearchSuggestions {
  final SearchRepository repository;

  GetSearchSuggestions(this.repository);

  Future<Either<Failure, List<SearchSuggestion>>> call({
    required String query,
    String? type,
    int? limit,
  }) async {
    return await repository.getSearchSuggestions(
      query: query,
      type: type,
      limit: limit,
    );
  }
}
