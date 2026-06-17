import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/domain/repositories/preorder_repository.dart';

class GetPreOrderDataUseCase {
  final PreOrderRepository repository;

  GetPreOrderDataUseCase(this.repository);

  Future<Either<Failure, PreOrderResponseEntity>> call({
    String? status,
  }) async {
    return await repository.getPreOrderData(status: status);
  }
}
