import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/farmer_products_repository.dart';
import '../datasources/remote/farmer_products_remote_datasource.dart';

class FarmerProductsRepositoryImpl implements FarmerProductsRepository {
  final FarmerProductsDataSource remoteDataSource;

  FarmerProductsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getFarmerProducts(
      String farmerId) async {
    try {
      final productModels = await remoteDataSource.getFarmerProducts(farmerId);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getFarmerReviews(
      String farmerId) async {
    try {
      final reviewModels = await remoteDataSource.getFarmerReviews(farmerId);
      final reviews = reviewModels.map((model) => model.toEntity()).toList();
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
