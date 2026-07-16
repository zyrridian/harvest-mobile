import 'package:equatable/equatable.dart';

class SecuritySettings extends Equatable {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final bool emailNotificationsEnabled;
  final DateTime? lastPasswordChange;
  final List<String> activeSessions;

  const SecuritySettings({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.emailNotificationsEnabled,
    this.lastPasswordChange,
    required this.activeSessions,
  });

  SecuritySettings copyWith({
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    bool? emailNotificationsEnabled,
    DateTime? lastPasswordChange,
    List<String>? activeSessions,
  }) {
    return SecuritySettings(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      lastPasswordChange: lastPasswordChange ?? this.lastPasswordChange,
      activeSessions: activeSessions ?? this.activeSessions,
    );
  }

  @override
  List<Object?> get props => [
        twoFactorEnabled,
        biometricEnabled,
        emailNotificationsEnabled,
        lastPasswordChange,
        activeSessions,
      ];
}
