import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';

class GetFarmerProductsUseCase {
  final ProducerRepository repository;

  GetFarmerProductsUseCase(this.repository);

  Future<Either<Failure, List<FarmerProduct>>> call({int page = 1, int limit = 20, String? status}) async {
    return await repository.getProducts(page: page, limit: limit, status: status);
  }
}
