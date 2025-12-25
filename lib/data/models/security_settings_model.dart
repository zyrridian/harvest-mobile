class SecuritySettingsModel {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final bool emailNotificationsEnabled;
  final String? lastPasswordChange;
  final List<String> activeSessions;

  SecuritySettingsModel({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.emailNotificationsEnabled,
    this.lastPasswordChange,
    required this.activeSessions,
  });

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return SecuritySettingsModel(
      twoFactorEnabled: json['twoFactorEnabled'] as bool,
      biometricEnabled: json['biometricEnabled'] as bool,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool,
      lastPasswordChange: json['lastPasswordChange'] as String?,
      activeSessions: (json['activeSessions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'twoFactorEnabled': twoFactorEnabled,
      'biometricEnabled': biometricEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'lastPasswordChange': lastPasswordChange,
      'activeSessions': activeSessions,
    };
  }
}
