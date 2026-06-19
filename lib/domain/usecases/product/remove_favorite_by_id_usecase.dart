import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product_repository.dart';

class RemoveFavoriteByIdUseCase {
  final ProductRepository repository;

  RemoveFavoriteByIdUseCase(this.repository);

  Future<Either<Failure, void>> call(String favoriteId) async {
    return await repository.removeFavoriteById(favoriteId);
  }
}
