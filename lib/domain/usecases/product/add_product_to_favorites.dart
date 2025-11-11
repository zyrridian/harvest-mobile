import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product_detail_repository.dart';

class AddProductToFavorites {
  final ProductDetailRepository repository;

  AddProductToFavorites(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.addToFavorites(productId);
  }
}
