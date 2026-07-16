import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/nearby_farmer.dart';

abstract class NearbyFarmerRepository {
  Future<Either<Failure, List<NearbyFarmerData>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 3.0,
    String? search,
    bool? isOrganic,
    bool? isOpenNow,
  });
}
