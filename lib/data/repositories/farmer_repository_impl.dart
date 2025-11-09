import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/farmer.dart';
import '../../domain/repositories/farmer_repository.dart';
import '../datasources/remote/farmer_remote_datasource.dart';

class FarmerRepositoryImpl implements FarmerRepository {
  final FarmerRemoteDataSource remoteDataSource;

  FarmerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Farmer>>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    try {
      final farmerModels = await remoteDataSource.getFarmers(
        query: query,
        specialties: specialties,
        hasMapFeature: hasMapFeature,
        maxDistance: maxDistance,
        minRating: minRating,
      );
      return Right(farmerModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Farmer>> getFarmerById(String id) async {
    try {
      final farmerModel = await remoteDataSource.getFarmerById(id);
      return Right(farmerModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Farmer>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    try {
      final farmerModels = await remoteDataSource.getNearbyFarmers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      return Right(farmerModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
