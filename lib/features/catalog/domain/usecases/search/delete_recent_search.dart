import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/catalog/domain/repositories/search_repository.dart';

class DeleteRecentSearch {
  final SearchRepository repository;

  DeleteRecentSearch(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.removeRecentSearch(id);
  }
}
