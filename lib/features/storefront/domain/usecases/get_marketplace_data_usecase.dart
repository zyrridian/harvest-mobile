import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/features/storefront/domain/repositories/marketplace_repository.dart';

class GetMarketplaceDataUseCase {
  final MarketplaceRepository repository;

  GetMarketplaceDataUseCase(this.repository);

  Future<Either<Failure, MarketplaceResponseEntity>> call({
    double? latitude,
    double? longitude,
    String? filter,
    String? search,
    int? page,
    int? limit,
  }) async {
    return await repository.getMarketplaceData(
      latitude: latitude,
      longitude: longitude,
      filter: filter,
      search: search,
      page: page,
      limit: limit,
    );
  }
}
