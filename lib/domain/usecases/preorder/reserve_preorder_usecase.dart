import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class ReservePreOrderUseCase {
  final PreorderRepository repository;

  ReservePreOrderUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String harvestId,
    required int quantity,
    required String deliveryMethod,
    String? addressId,
  }) async {
    return await repository.reserveSpot(
      harvestId,
      quantity,
      deliveryMethod,
      addressId,
    );
  }
}
