import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/storefront/domain/entities/marketplace.dart';

abstract class MarketplaceRepository {
  Future<Either<Failure, MarketplaceResponseEntity>> getMarketplaceData({
    double? latitude,
    double? longitude,
    String? filter,
    String? search,
    int? page,
    int? limit,
  });

  Future<Either<Failure, Map<String, dynamic>>> addToCart({
    required String productId,
    required int quantity,
  });
}
