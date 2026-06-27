import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/catalog/domain/repositories/search_repository.dart';

class SaveRecentSearch {
  final SearchRepository repository;

  SaveRecentSearch(this.repository);

  Future<Either<Failure, void>> call(String query) async {
    return await repository.saveRecentSearch(query);
  }
}
