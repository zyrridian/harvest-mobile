import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/farmer.dart';

abstract class FarmerRepository {
  Future<Either<Failure, List<Farmer>>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  });

  Future<Either<Failure, Farmer>> getFarmerById(String id);

  Future<Either<Failure, List<Farmer>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0, // in km
  });
}
