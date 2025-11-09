import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/farmer.dart';
import '../../repositories/farmer_repository.dart';

class GetFarmers {
  final FarmerRepository repository;

  GetFarmers(this.repository);

  Future<Either<Failure, List<Farmer>>> call({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    return await repository.getFarmers(
      query: query,
      specialties: specialties,
      hasMapFeature: hasMapFeature,
      maxDistance: maxDistance,
      minRating: minRating,
    );
  }
}
