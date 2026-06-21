import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/nearby_farmer.dart';
import '../repositories/nearby_farmer_repository.dart';

class GetNearbyFarmersParams {
  final double latitude;
  final double longitude;
  final double radius;
  final String? search;
  final bool? isOrganic;
  final bool? isOpenNow;

  GetNearbyFarmersParams({
    required this.latitude,
    required this.longitude,
    this.radius = 3.0,
    this.search,
    this.isOrganic,
    this.isOpenNow,
  });
}

class GetNearbyFarmersUsecase {
  final NearbyFarmerRepository repository;

  GetNearbyFarmersUsecase(this.repository);

  Future<Either<Failure, List<NearbyFarmerData>>> call(GetNearbyFarmersParams params) {
    return repository.getNearbyFarmers(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      search: params.search,
      isOrganic: params.isOrganic,
      isOpenNow: params.isOpenNow,
    );
  }
}
