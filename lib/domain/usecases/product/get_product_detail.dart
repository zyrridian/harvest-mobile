import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/product_detail.dart';
import '../../repositories/product_detail_repository.dart';

class GetProductDetail {
  final ProductDetailRepository repository;

  GetProductDetail(this.repository);

  Future<Either<Failure, ProductDetail>> call(String productId) async {
    return await repository.getProductDetail(productId);
  }
}
