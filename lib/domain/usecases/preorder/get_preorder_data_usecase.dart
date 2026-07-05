import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetPreOrderDataUseCase {
  final PreorderRepository repository;

  GetPreOrderDataUseCase(this.repository);

  Future<Either<Failure, PreOrderResponseEntity>> call({
    double? latitude,
    double? longitude,
  }) async {
    return await repository.getPreorderData(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
