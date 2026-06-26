import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/remote/preorder_remote_datasource.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/data/models/preorder/campaign_model.dart';
import 'package:harvest_app/domain/repositories/preorder_repository.dart';

class PreOrderRepositoryImpl implements PreOrderRepository {
  final PreOrderRemoteDataSource remoteDataSource;

  PreOrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PreOrderResponseEntity>> getPreOrderData({String? status}) async {
    try {
      final model = await remoteDataSource.getPreOrderData(status: status);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  }) async {
    try {
      final result = await remoteDataSource.reserveSpot(
        harvestId,
        quantity,
        'Pickup',
        null,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PreorderCampaign>> createCampaign(PreorderCampaign campaign) async {
    try {
      final result = await remoteDataSource.createCampaign(campaign as PreorderCampaignModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PreorderCampaign>>> getActiveCampaigns() async {
    try {
      final result = await remoteDataSource.getActiveCampaigns();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PreorderCampaign>>> getMyCampaigns() async {
    try {
      final result = await remoteDataSource.getMyCampaigns();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> reserveSpot(String id, int quantity, String deliveryMethod, String? addressId) async {
    try {
      final result = await remoteDataSource.reserveSpot(id, quantity, deliveryMethod, addressId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> payDeposit(String id, String paymentMethod) async {
    try {
      final result = await remoteDataSource.payDeposit(id, paymentMethod);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> arrangePickup(String id, DateTime pickupTime) async {
    try {
      final result = await remoteDataSource.arrangePickup(id, pickupTime);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> cancelReservation(String id) async {
    try {
      final result = await remoteDataSource.cancelReservation(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
