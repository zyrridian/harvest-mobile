import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product_repository.dart';
import '../../entities/favorite_status.dart';

class AddFavoriteUseCase {
  final ProductRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<Either<Failure, FavoriteStatus>> call(String productId) async {
    return await repository.addToFavorites(productId);
  }
}
