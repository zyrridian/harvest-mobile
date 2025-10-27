import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/search_repository.dart';

class SaveRecentSearch {
  final SearchRepository repository;

  SaveRecentSearch(this.repository);

  Future<Either<Failure, void>> call(String query) async {
    return await repository.saveRecentSearch(query);
  }
}
