import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/search_repository.dart';

class GetRecentSearches {
  final SearchRepository repository;

  GetRecentSearches(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getRecentSearches();
  }
}
