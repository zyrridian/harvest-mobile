import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/data/datasources/remote/producer_remote_datasource.dart';
import 'package:harvest_app/features/farmers/data/datasources/local/producer_local_datasource.dart';
import 'package:harvest_app/features/farmers/data/models/delivery_settings_model.dart';
import 'package:harvest_app/features/farmers/data/models/farmer_product_detail_model.dart';
import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_request.dart';
import 'package:harvest_app/features/farmers/domain/entities/drop_point.dart';
import 'package:harvest_app/features/farmers/domain/entities/farm_profile_request.dart';
import 'package:harvest_app/features/farmers/domain/entities/farm_review.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_profile.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_stats.dart';
import 'package:harvest_app/features/farmers/domain/repositories/producer_repository.dart';
import 'package:harvest_app/features/farmers/data/models/farm_profile_request_model.dart';
import 'package:harvest_app/features/farmers/data/models/drop_point_model.dart';

class ProducerRepositoryImpl implements ProducerRepository {
  final ProducerRemoteDataSource remoteDataSource;
  final ProducerLocalDataSource? localDataSource;

  ProducerRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<Either<Failure, FarmerStats>> getStats() async {
    try {
      final model = await remoteDataSource.getStats();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProfile>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProfile>> updateProfile(
      FarmProfileRequest profile) async {
    try {
      final requestModel = FarmProfileRequestModel.fromEntity(profile);
      final model = await remoteDataSource.updateProfile(requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeliverySettings>> getDeliverySettings() async {
    try {
      final model = await remoteDataSource.getDeliverySettings();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeliverySettings>> updateDeliverySettings(
      DeliverySettings settings) async {
    try {
      final requestModel = DeliverySettingsModel(
        farmerDeliveryEnabled: settings.farmerDeliveryEnabled,
        baseFee: settings.baseFee,
        perKmRate: settings.perKmRate,
        maxRadiusKm: settings.maxRadiusKm,
        minOrderForFree: settings.minOrderForFree,
        cashOnDeliveryEnabled: settings.cashOnDeliveryEnabled,
        notes: settings.notes,
      );
      final model = await remoteDataSource.updateDeliverySettings(requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmReviewResponse>> getReviews(
      {int page = 1, int limit = 20}) async {
    try {
      final model = await remoteDataSource.getReviews(page: page, limit: limit);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DropPoint>>> getDropPoints() async {
    try {
      final models = await remoteDataSource.getDropPoints();
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DropPoint>> createDropPoint(
      DropPoint dropPoint) async {
    try {
      final requestModel = DropPointModel.fromEntity(dropPoint);
      final model = await remoteDataSource.createDropPoint(requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DropPoint>> updateDropPoint(
      String id, DropPoint dropPoint) async {
    try {
      final requestModel = DropPointModel.fromEntity(dropPoint);
      final model = await remoteDataSource.updateDropPoint(id, requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDropPoint(String id) async {
    try {
      await remoteDataSource.deleteDropPoint(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FarmerProduct>>> getProducts(
      {int page = 1, int limit = 20, String? status}) async {
    try {
      final models = await remoteDataSource.getProducts(
          page: page, limit: limit, status: status);
      if (localDataSource != null &&
          page == 1 &&
          (status == null || status == 'all')) {
        localDataSource!.saveFarmerProducts(models);
      }
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      if (localDataSource != null && page == 1) {
        try {
          final cached = await localDataSource!.getFarmerProducts();
          if (cached != null) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
        } catch (_) {}
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProductDetail>> getProductDetail(
      String id) async {
    try {
      final model = await remoteDataSource.getProductDetail(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProductDetail>> createProduct(
      ProductRequest product) async {
    try {
      final requestModel = ProductRequestModel.fromEntity(product);
      final model = await remoteDataSource.createProduct(requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FarmerProductDetail>> updateProduct(
      String id, ProductRequest product) async {
    try {
      final requestModel = ProductRequestModel.fromEntity(product);
      final model = await remoteDataSource.updateProduct(id, requestModel);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleProductAvailability(
      String id, bool isAvailable) async {
    try {
      await remoteDataSource.toggleProductAvailability(id, isAvailable);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FarmerOrder>>> getOrders(
      {int page = 1, int limit = 20, String status = 'all'}) async {
    try {
      final models = await remoteDataSource.getOrders(
          page: page, limit: limit, status: status);
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
      String orderId, String status) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPreorderDashboard(
      {String? status}) async {
    try {
      final result =
          await remoteDataSource.getPreorderDashboard(status: status);
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
