import '../../domain/entities/security_settings.dart';
import '../datasources/security_settings_local_datasource.dart';
import '../models/security_settings_model.dart';

class SecuritySettingsRepository {
  final SecuritySettingsLocalDataSource _localDataSource;

  SecuritySettingsRepository(this._localDataSource);

  Future<SecuritySettings> getSecuritySettings() async {
    final model = await _localDataSource.getSecuritySettings();
    return _toEntity(model);
  }

  Future<SecuritySettings> updateTwoFactor(bool enabled) async {
    final model = await _localDataSource.updateTwoFactor(enabled);
    return _toEntity(model);
  }

  Future<SecuritySettings> updateBiometric(bool enabled) async {
    final model = await _localDataSource.updateBiometric(enabled);
    return _toEntity(model);
  }

  Future<SecuritySettings> updateEmailNotifications(bool enabled) async {
    final model = await _localDataSource.updateEmailNotifications(enabled);
    return _toEntity(model);
  }

  Future<void> terminateSession(String sessionName) async {
    await _localDataSource.terminateSession(sessionName);
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await _localDataSource.changePassword(currentPassword, newPassword);
  }

  SecuritySettings _toEntity(SecuritySettingsModel model) {
    return SecuritySettings(
      twoFactorEnabled: model.twoFactorEnabled,
      biometricEnabled: model.biometricEnabled,
      emailNotificationsEnabled: model.emailNotificationsEnabled,
      lastPasswordChange: model.lastPasswordChange != null
          ? DateTime.parse(model.lastPasswordChange!)
          : null,
      activeSessions: model.activeSessions,
    );
  }
}
