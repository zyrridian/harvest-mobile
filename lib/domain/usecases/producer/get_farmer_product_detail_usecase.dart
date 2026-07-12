import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class GetFarmerProductDetailUseCase {
  final ProducerRepository repository;

  GetFarmerProductDetailUseCase(this.repository);

  Future<Either<Failure, FarmerProductDetail>> call(String id) async {
    return await repository.getProductDetail(id);
  }
}
