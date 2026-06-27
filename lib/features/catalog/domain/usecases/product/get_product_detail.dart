import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/product_detail.dart';
import '../../repositories/product_repository.dart';

class GetProductDetail {
  final ProductRepository repository;

  GetProductDetail(this.repository);

  Future<Either<Failure, ProductDetail>> call(String slug) async {
    return await repository.getProductDetail(slug);
  }
}
