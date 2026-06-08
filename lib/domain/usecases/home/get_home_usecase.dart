import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/home.dart';
import 'package:harvest_app/domain/repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  Future<Either<Failure, Home>> call({
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    // TODO: Consider using actual radius parameter instead of hardcoded value
    return await repository.getHomeData(
        latitude: latitude, longitude: longitude, radius: 1000.0); // radius);
  }
}
