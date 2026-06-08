import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/farmer.dart';
import '../../domain/repositories/farmer_repository.dart';
import '../datasources/local/farmer_local_datasource.dart';
import '../datasources/remote/farmer_remote_datasource.dart';

class FarmerRepositoryImpl implements FarmerRepository {
  final FarmerRemoteDataSource remoteDataSource;
  final FarmerLocalDataSource localDataSource;

  FarmerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Farmer>>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    try {
      // Try to fetch from local database first
      final localFarmers = await localDataSource.getFarmers(
        query: query,
        specialties: specialties,
        hasMapFeature: hasMapFeature,
        maxDistance: maxDistance,
        minRating: minRating,
      );

      // Return local data immediately if available
      if (localFarmers.isNotEmpty) {
        // Fetch from remote in background to update cache
        _syncFarmersInBackground(
          query: query,
          specialties: specialties,
          hasMapFeature: hasMapFeature,
          maxDistance: maxDistance,
          minRating: minRating,
        );

        return Right(localFarmers.map((model) => model.toEntity()).toList());
      }

      // If no local data, fetch from remote
      final remoteFarmers = await remoteDataSource.getFarmers(
        query: query,
        specialties: specialties,
        hasMapFeature: hasMapFeature,
        maxDistance: maxDistance,
        minRating: minRating,
      );

      // Save to local database
      await localDataSource.saveFarmers(remoteFarmers);

      return Right(remoteFarmers.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      // If network error, try to return cached data
      try {
        final localFarmers = await localDataSource.getFarmers(
          query: query,
          specialties: specialties,
          hasMapFeature: hasMapFeature,
          maxDistance: maxDistance,
          minRating: minRating,
        );
        return Right(localFarmers.map((model) => model.toEntity()).toList());
      } catch (_) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Farmer>> getFarmerById(String id) async {
    try {
      // Try local first
      final localFarmer = await localDataSource.getFarmerById(id);

      if (localFarmer != null) {
        // Fetch from remote in background to update cache
        _syncFarmerByIdInBackground(id);
        return Right(localFarmer.toEntity());
      }

      // If not in local, fetch from remote
      final remoteFarmer = await remoteDataSource.getFarmerById(id);

      // Save to local database
      await localDataSource.saveFarmer(remoteFarmer);

      return Right(remoteFarmer.toEntity());
    } on NetworkException catch (e) {
      // If network error, try to return cached data
      try {
        final localFarmer = await localDataSource.getFarmerById(id);
        if (localFarmer != null) {
          return Right(localFarmer.toEntity());
        }
        return Left(NetworkFailure(e.message));
      } catch (_) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
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
      // Try local first
      final localFarmers = await localDataSource.getNearbyFarmers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      if (localFarmers.isNotEmpty) {
        // Sync in background
        _syncNearbyFarmersInBackground(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );

        return Right(localFarmers.map((model) => model.toEntity()).toList());
      }

      // Fetch from remote
      final remoteFarmers = await remoteDataSource.getNearbyFarmers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      // Save to local
      await localDataSource.saveFarmers(remoteFarmers);

      return Right(remoteFarmers.map((model) => model.toEntity()).toList());
    } on NetworkException catch (e) {
      // Return cached data on network error
      try {
        final localFarmers = await localDataSource.getNearbyFarmers(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        return Right(localFarmers.map((model) => model.toEntity()).toList());
      } catch (_) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Background sync methods (fire and forget)
  void _syncFarmersInBackground({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) {
    remoteDataSource
        .getFarmers(
      query: query,
      specialties: specialties,
      hasMapFeature: hasMapFeature,
      maxDistance: maxDistance,
      minRating: minRating,
    )
        .then((farmers) {
      localDataSource.saveFarmers(farmers);
    }).catchError((_) {
      // Silently fail - we already have local data
    });
  }

  void _syncFarmerByIdInBackground(String id) {
    remoteDataSource.getFarmerById(id).then((farmer) {
      localDataSource.saveFarmer(farmer);
    }).catchError((_) {
      // Silently fail
    });
  }

  void _syncNearbyFarmersInBackground({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) {
    remoteDataSource
        .getNearbyFarmers(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    )
        .then((farmers) {
      localDataSource.saveFarmers(farmers);
    }).catchError((_) {
      // Silently fail
    });
  }
}
