import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/data/datasources/remote/preorder_remote_datasource.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/domain/repositories/preorder_repository.dart';

class PreOrderRepositoryImpl implements PreOrderRepository {
  final PreOrderRemoteDataSource remoteDataSource;

  PreOrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PreOrderResponseEntity>> getPreOrderData({String? status}) async {
    try {
      final model = await remoteDataSource.getPreOrderData(status: status);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  }) async {
    try {
      final result = await remoteDataSource.reservePreOrder(
        harvestId: harvestId,
        quantity: quantity,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
