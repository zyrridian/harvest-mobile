import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_order.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class GetFarmerOrdersUseCase {
  final ProducerRepository repository;

  GetFarmerOrdersUseCase(this.repository);

  Future<Either<Failure, List<FarmerOrder>>> call({int page = 1, int limit = 20, String status = 'all'}) async {
    return await repository.getOrders(page: page, limit: limit, status: status);
  }
}
