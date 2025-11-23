import 'package:dartz/dartz.dart';
import '../entities/product_detail.dart';
import '../../core/error/failure.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(String productId);
  Future<Either<Failure, void>> addToFavorites(String productId);
  Future<Either<Failure, void>> removeFromFavorites(String productId);
  Future<Either<Failure, void>> trackProductView(String productId);
}
