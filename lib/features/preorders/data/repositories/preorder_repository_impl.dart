import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';
import 'package:harvest_app/features/preorders/data/datasources/local/preorder_local_datasource.dart';
import 'package:harvest_app/features/preorders/data/datasources/remote/preorder_remote_datasource.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/data/models/preorder/campaign_model.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class PreorderRepositoryImpl implements PreorderRepository {
  final PreOrderRemoteDataSource remoteDataSource;
  final PreorderLocalDataSource localDataSource;

  PreorderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PreOrderResponseEntity>> getPreorderData({
    double? latitude,
    double? longitude,
  }) async {
    try {
      // Always try to fetch fresh data from remote first
      final remoteData = await remoteDataSource.getPreOrderData(
        latitude: latitude,
        longitude: longitude,
      );

      // Save to local storage for offline fallback
      await localDataSource.savePreorderData(remoteData);

      return Right(remoteData.toEntity());
    } catch (e) {
      // If remote fails (e.g. no internet), try to get from local cache
      try {
        final localData = await localDataSource.getPreorderData();
        if (localData != null) {
          return Right(localData.toEntity());
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
  Future<Either<Failure, List<PreorderCampaign>>> getActiveCampaigns() async {
    try {
      final campaigns = await remoteDataSource.getActiveCampaigns();
      return Right(campaigns);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  }) async {
    try {
      // Default to PICKUP as required by API for now.
      final result = await remoteDataSource.reserveSpot(harvestId, quantity, 'PICKUP', null);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, PreorderCampaign>> createCampaign(CreatePreorderCampaignParams params) async {
    try {
      final result = await remoteDataSource.createCampaign(params);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<PreorderCampaign>>> getMyCampaigns() async {
    try {
      final result = await remoteDataSource.getMyCampaigns();
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> reserveSpot(String id, int quantity, String deliveryMethod, String? addressId) async {
    try {
      final result = await remoteDataSource.reserveSpot(id, quantity, deliveryMethod, addressId);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> payDeposit(String id, String paymentMethod) async {
    try {
      final result = await remoteDataSource.payDeposit(id, paymentMethod);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> arrangePickup(String id, DateTime pickupTime) async {
    try {
      final result = await remoteDataSource.arrangePickup(id, pickupTime);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> cancelReservation(String id) async {
    try {
      final result = await remoteDataSource.cancelReservation(id);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
