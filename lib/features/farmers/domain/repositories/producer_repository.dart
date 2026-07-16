import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/farmers/domain/entities/drop_point.dart';
import 'package:harvest_app/features/farmers/domain/entities/farm_review.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_profile.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_stats.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_request.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';
import 'package:harvest_app/features/farmers/domain/entities/farm_profile_request.dart';

abstract class ProducerRepository {
  Future<Either<Failure, FarmerStats>> getStats();
  Future<Either<Failure, FarmerProfile>> getProfile();
  Future<Either<Failure, FarmerProfile>> updateProfile(
      FarmProfileRequest profile);
  Future<Either<Failure, DeliverySettings>> getDeliverySettings();
  Future<Either<Failure, DeliverySettings>> updateDeliverySettings(
      DeliverySettings settings);
  Future<Either<Failure, FarmReviewResponse>> getReviews(
      {int page = 1, int limit = 20});
  Future<Either<Failure, List<DropPoint>>> getDropPoints();
  Future<Either<Failure, DropPoint>> createDropPoint(DropPoint dropPoint);
  Future<Either<Failure, DropPoint>> updateDropPoint(
      String id, DropPoint dropPoint);
  Future<Either<Failure, void>> deleteDropPoint(String id);
  Future<Either<Failure, List<FarmerProduct>>> getProducts(
      {int page = 1, int limit = 20, String? status});
  Future<Either<Failure, FarmerProductDetail>> getProductDetail(String id);
  Future<Either<Failure, FarmerProductDetail>> createProduct(
      ProductRequest product);
  Future<Either<Failure, FarmerProductDetail>> updateProduct(
      String id, ProductRequest product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, void>> toggleProductAvailability(
      String id, bool isAvailable);
  Future<Either<Failure, List<FarmerOrder>>> getOrders(
      {int page = 1, int limit = 20, String status = 'all'});
  Future<Either<Failure, void>> updateOrderStatus(
      String orderId, String status);
  Future<Either<Failure, Map<String, dynamic>>> getPreorderDashboard(
      {String? status});
}
