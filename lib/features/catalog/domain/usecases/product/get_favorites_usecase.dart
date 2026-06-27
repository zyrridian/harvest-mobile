import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/product_repository.dart';
import '../../entities/favorite_product.dart';

class GetFavoritesUseCase {
  final ProductRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, FavoriteProductList>> call() async {
    return await repository.getUserFavorites();
  }
}
