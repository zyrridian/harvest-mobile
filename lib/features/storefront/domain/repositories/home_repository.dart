import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/storefront/domain/entities/home.dart';

abstract class HomeRepository {
  /// Fetch home data for the dashboard
  Future<Either<Failure, Home>> getHomeData();
}
