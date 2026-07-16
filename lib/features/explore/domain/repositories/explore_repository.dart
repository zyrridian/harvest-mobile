import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import '../../../../domain/entities/explore.dart';

abstract class ExploreRepository {
  Future<Either<Failure, Explore>> getExploreData();
}
