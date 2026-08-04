import 'package:dartz/dartz.dart';
import 'package:harvest_app/features/farmers/domain/entities/nearby_farmer.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/nearby_farmer_repository.dart';
import '../datasources/remote/nearby_farmer_remote_datasource.dart';

class NearbyFarmerRepositoryImpl implements NearbyFarmerRepository {
  final NearbyFarmerRemoteDataSource remoteDataSource;

  NearbyFarmerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NearbyFarmerData>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 3.0,
    String? search,
    bool? isOrganic,
    bool? isOpenNow,
  }) async {
    try {
      final result = await remoteDataSource.getNearbyFarmers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: search,
        isOrganic: isOrganic,
        isOpenNow: isOpenNow,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
