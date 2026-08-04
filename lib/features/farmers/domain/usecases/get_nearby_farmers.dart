import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:harvest_app/features/farmers/domain/repositories/farmer_repository.dart';

class GetNearbyFarmers {
  final FarmerRepository repository;

  GetNearbyFarmers(this.repository);

  Future<Either<Failure, PaginatedResponse<Farmer>>> call({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    int? limit,
    int? page,
  }) async {
    return await repository.getNearbyFarmers(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      limit: limit,
      page: page,
    );
  }
}
