import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/favorite_status.dart';
import '../../repositories/product_repository.dart';

class CheckFavoriteStatus {
  final ProductRepository repository;

  CheckFavoriteStatus(this.repository);

  Future<Either<Failure, FavoriteStatus>> call(String slug) async {
    return await repository.checkFavoriteStatus(slug);
  }
}
