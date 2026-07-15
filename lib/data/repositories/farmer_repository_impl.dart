import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/farmer.dart';
import '../../domain/entities/farmer_detail.dart';
import '../../domain/entities/paginated_response.dart';
import '../../domain/entities/farmer_gallery_image.dart';
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
  Future<Either<Failure, PaginatedResponse<Farmer>>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
    int? limit,
    int? page,
    String? sortBy,
    double? latitude,
    double? longitude,
  }) async {
    try {
      // Always try to fetch fresh data from remote first
      final remoteResponse = await remoteDataSource.getFarmers(
        query: query,
        specialties: specialties,
        hasMapFeature: hasMapFeature,
        maxDistance: maxDistance,
        minRating: minRating,
        limit: limit,
        page: page,
        sortBy: sortBy,
        latitude: latitude,
        longitude: longitude,
      );

      // Save to local storage for offline fallback
      await localDataSource.saveFarmers(remoteResponse.data);

      return Right(remoteResponse.toEntity((model) => model.toEntity()));
    } catch (e) {
      // If remote fails, try to get from local cache
      try {
        final localFarmers = await localDataSource.getFarmers(
          query: query,
          specialties: specialties,
          hasMapFeature: hasMapFeature,
          maxDistance: maxDistance,
          minRating: minRating,
        );
        if (localFarmers.isNotEmpty) {
          final mappedFarmers = localFarmers.map((model) => model.toEntity()).toList();
          return Right(PaginatedResponse<Farmer>(
            data: mappedFarmers,
            pagination: Pagination(
              currentPage: 1,
              totalPages: 1,
              totalItems: mappedFarmers.length,
              itemsPerPage: mappedFarmers.length,
            ),
          ));
        }
      } catch (_) {
        // Ignore local cache error, handle the remote error below
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Farmer>> getFarmerById(String id) async {
    try {
      // Always try to fetch fresh data from remote first
      final remoteFarmer = await remoteDataSource.getFarmerById(id);

      // Save to local database
      await localDataSource.saveFarmer(remoteFarmer);

      return Right(remoteFarmer.toEntity());
    } catch (e) {
      // If remote fails, try to get from local cache
      try {
        final localFarmer = await localDataSource.getFarmerById(id);
        if (localFarmer != null) {
          return Right(localFarmer.toEntity());
        }
      } catch (_) {
        // Ignore local cache error, handle the remote error below
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, FarmerDetail>> getFarmerDetailById(String id) async {
    try {
      final remoteFarmerDetail = await remoteDataSource.getFarmerDetailById(id);
      return Right(remoteFarmerDetail.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<Farmer>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int? limit,
    int? page,
  }) async {
    try {
      // Always try to fetch fresh data from remote first
      final remoteResponse = await remoteDataSource.getNearbyFarmers(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        limit: limit,
        page: page,
      );

      // Save to local
      await localDataSource.saveFarmers(remoteResponse.data);

      return Right(remoteResponse.toEntity((model) => model.toEntity()));
    } catch (e) {
      // If remote fails, try to get from local cache
      try {
        final localFarmers = await localDataSource.getNearbyFarmers(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        if (localFarmers.isNotEmpty) {
          final mappedFarmers = localFarmers.map((model) => model.toEntity()).toList();
          return Right(PaginatedResponse<Farmer>(
            data: mappedFarmers,
            pagination: Pagination(
              currentPage: 1,
              totalPages: 1,
              totalItems: mappedFarmers.length,
              itemsPerPage: mappedFarmers.length,
            ),
          ));
        }
      } catch (_) {
        // Ignore local cache error, handle the remote error below
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> followFarmer(String id) async {
    try {
      await remoteDataSource.followFarmer(id);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> unfollowFarmer(String id) async {
    try {
      await remoteDataSource.unfollowFarmer(id);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<FarmerGalleryImage>>> getFarmerGallery() async {
    try {
      final remoteModels = await remoteDataSource.getFarmerGallery();
      return Right(remoteModels.map((m) => m.toEntity()).toList());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, FarmerGalleryImage>> addGalleryImage(String imageUrl, {String? caption}) async {
    try {
      final remoteModel = await remoteDataSource.addGalleryImage(imageUrl, caption: caption);
      return Right(remoteModel.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteGalleryImage(String id) async {
    try {
      await remoteDataSource.deleteGalleryImage(id);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
