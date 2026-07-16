import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateAppSettings {
  final SettingsRepository repository;

  UpdateAppSettings(this.repository);

  Future<Either<Failure, AppSettings>> call(Map<String, dynamic> updates) {
    return repository.updateAppSettings(updates);
  }
}
