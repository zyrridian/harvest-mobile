import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/storefront/domain/repositories/marketplace_repository.dart';

class AddToCartUseCase {
  final MarketplaceRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String productId,
    required int quantity,
  }) async {
    return await repository.addToCart(
      productId: productId,
      quantity: quantity,
    );
  }
}
