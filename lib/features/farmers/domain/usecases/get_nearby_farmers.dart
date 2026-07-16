import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/farmer.dart';
import '../../../../domain/entities/paginated_response.dart';
import '../repositories/farmer_repository.dart';

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
