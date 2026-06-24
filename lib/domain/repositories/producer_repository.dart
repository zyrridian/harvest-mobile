import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_stats.dart';
import 'package:harvest_app/domain/entities/farmer_profile.dart';
import 'package:harvest_app/domain/entities/delivery_settings.dart';
import 'package:harvest_app/domain/entities/farmer_product.dart';
import 'package:harvest_app/domain/entities/farmer_order.dart';
import 'package:harvest_app/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/domain/entities/product_request.dart';

abstract class ProducerRepository {
  Future<Either<Failure, FarmerStats>> getStats();
  Future<Either<Failure, FarmerProfile>> getProfile();
  Future<Either<Failure, DeliverySettings>> getDeliverySettings();
  Future<Either<Failure, List<FarmerProduct>>> getProducts({int page = 1, int limit = 20, String? status});
  Future<Either<Failure, FarmerProductDetail>> getProductDetail(String id);
  Future<Either<Failure, FarmerProductDetail>> createProduct(ProductRequest product);
  Future<Either<Failure, FarmerProductDetail>> updateProduct(String id, ProductRequest product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, void>> toggleProductAvailability(String id, bool isAvailable);
  Future<Either<Failure, List<FarmerOrder>>> getOrders({int page = 1, int limit = 20, String status = 'all'});
}
