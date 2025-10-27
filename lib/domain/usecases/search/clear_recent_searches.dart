import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/search_repository.dart';

class ClearRecentSearches {
  final SearchRepository repository;

  ClearRecentSearches(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearRecentSearches();
  }
}
