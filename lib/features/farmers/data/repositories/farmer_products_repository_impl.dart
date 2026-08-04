import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../community/domain/entities/review.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/repositories/farmer_products_repository.dart';
import '../datasources/remote/farmer_products_remote_datasource.dart';
import '../../../../../core/error/exceptions.dart';

class FarmerProductsRepositoryImpl implements FarmerProductsRepository {
  final FarmerProductsDataSource remoteDataSource;

  FarmerProductsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PaginatedResponse<Product>>> getFarmerProducts(String farmerId, {int? limit, int? page}) async {
    try {
      final response = await remoteDataSource.getFarmerProducts(farmerId, limit: limit, page: page);
      return Right(response.toEntity((model) => model.toEntity()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<Review>>> getFarmerReviews(String farmerId, {int? limit, int? page}) async {
    try {
      final response = await remoteDataSource.getFarmerReviews(farmerId, limit: limit, page: page);
      return Right(response.toEntity((model) => model.toEntity()));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
