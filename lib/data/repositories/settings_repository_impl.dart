import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../features/users/domain/repositories/settings_repository.dart';
import '../../features/users/data/datasources/remote/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppSettings>> getAppSettings() async {
    try {
      final model = await remoteDataSource.getAppSettings();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppSettings>> updateAppSettings(
      Map<String, dynamic> updates) async {
    try {
      final model = await remoteDataSource.updateAppSettings(updates);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
