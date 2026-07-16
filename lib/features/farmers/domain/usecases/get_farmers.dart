import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:harvest_app/features/farmers/domain/repositories/farmer_repository.dart';

class GetFarmers {
  final FarmerRepository repository;

  GetFarmers(this.repository);

  Future<Either<Failure, PaginatedResponse<Farmer>>> call({
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
    return await repository.getFarmers(
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
  }
}
