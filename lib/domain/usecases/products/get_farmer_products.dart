import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/product.dart';
import '../../repositories/farmer_products_repository.dart';

class GetFarmerProducts {
  final FarmerProductsRepository repository;

  GetFarmerProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String farmerId) async {
    return await repository.getFarmerProducts(farmerId);
  }
}
