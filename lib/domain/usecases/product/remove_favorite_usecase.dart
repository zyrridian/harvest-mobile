import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product_repository.dart';
import '../../entities/favorite_status.dart';

class RemoveFavoriteUseCase {
  final ProductRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<Either<Failure, FavoriteStatus>> call(String productId) async {
    return await repository.removeFromFavorites(productId);
  }
}
