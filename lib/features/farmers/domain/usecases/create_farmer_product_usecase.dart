import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_request.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class CreateFarmerProductUseCase {
  final ProducerRepository repository;

  CreateFarmerProductUseCase(this.repository);

  Future<Either<Failure, FarmerProductDetail>> call(ProductRequest request) async {
    return await repository.createProduct(request);
  }
}
