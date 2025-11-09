import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/farmer.dart';
import '../../repositories/farmer_repository.dart';

class GetNearbyFarmers {
  final FarmerRepository repository;

  GetNearbyFarmers(this.repository);

  Future<Either<Failure, List<Farmer>>> call({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    return await repository.getNearbyFarmers(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
