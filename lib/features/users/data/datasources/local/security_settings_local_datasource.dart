import '../../../../../data/models/security_settings_model.dart';

class SecuritySettingsLocalDataSource {
  // Simulated in-memory security settings
  SecuritySettingsModel _securitySettings = SecuritySettingsModel(
    twoFactorEnabled: false,
    biometricEnabled: true,
    emailNotificationsEnabled: true,
    lastPasswordChange: DateTime(2024, 11, 1).toIso8601String(),
    activeSessions: ['Current Device', 'Mobile App - iOS'],
  );

  Future<SecuritySettingsModel> getSecuritySettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _securitySettings;
  }

  Future<SecuritySettingsModel> updateTwoFactor(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _securitySettings = SecuritySettingsModel(
      twoFactorEnabled: enabled,
      biometricEnabled: _securitySettings.biometricEnabled,
      emailNotificationsEnabled: _securitySettings.emailNotificationsEnabled,
      lastPasswordChange: _securitySettings.lastPasswordChange,
      activeSessions: _securitySettings.activeSessions,
    );

    return _securitySettings;
  }

  Future<SecuritySettingsModel> updateBiometric(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _securitySettings = SecuritySettingsModel(
      twoFactorEnabled: _securitySettings.twoFactorEnabled,
      biometricEnabled: enabled,
      emailNotificationsEnabled: _securitySettings.emailNotificationsEnabled,
      lastPasswordChange: _securitySettings.lastPasswordChange,
      activeSessions: _securitySettings.activeSessions,
    );

    return _securitySettings;
  }

  Future<SecuritySettingsModel> updateEmailNotifications(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 600));

    _securitySettings = SecuritySettingsModel(
      twoFactorEnabled: _securitySettings.twoFactorEnabled,
      biometricEnabled: _securitySettings.biometricEnabled,
      emailNotificationsEnabled: enabled,
      lastPasswordChange: _securitySettings.lastPasswordChange,
      activeSessions: _securitySettings.activeSessions,
    );

    return _securitySettings;
  }

  Future<void> terminateSession(String sessionName) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final sessions = List<String>.from(_securitySettings.activeSessions);
    sessions.remove(sessionName);

    _securitySettings = SecuritySettingsModel(
      twoFactorEnabled: _securitySettings.twoFactorEnabled,
      biometricEnabled: _securitySettings.biometricEnabled,
      emailNotificationsEnabled: _securitySettings.emailNotificationsEnabled,
      lastPasswordChange: _securitySettings.lastPasswordChange,
      activeSessions: sessions,
    );
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _securitySettings = SecuritySettingsModel(
      twoFactorEnabled: _securitySettings.twoFactorEnabled,
      biometricEnabled: _securitySettings.biometricEnabled,
      emailNotificationsEnabled: _securitySettings.emailNotificationsEnabled,
      lastPasswordChange: DateTime.now().toIso8601String(),
      activeSessions: _securitySettings.activeSessions,
    );
  }
}
