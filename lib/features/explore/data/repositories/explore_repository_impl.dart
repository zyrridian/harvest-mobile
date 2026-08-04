import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/explore/domain/entities/explore.dart';
import 'package:harvest_app/features/explore/domain/repositories/explore_repository.dart';
import 'package:harvest_app/features/explore/data/datasources/remote/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Explore>> getExploreData() async {
    try {
      final exploreModel = await remoteDataSource.getExploreData();
      return Right(exploreModel.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
