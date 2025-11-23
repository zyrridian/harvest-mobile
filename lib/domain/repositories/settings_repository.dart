import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getAppSettings();
  Future<Either<Failure, AppSettings>> updateAppSettings(
      Map<String, dynamic> updates);
}
