import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String theme; // light, dark, auto
  final String language;
  final String currency;
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final DisplaySettings display;
  final bool searchHistoryEnabled;
  final bool locationServicesEnabled;
  final bool biometricEnabled;
  final DateTime syncedAt;

  const AppSettings({
    required this.theme,
    required this.language,
    required this.currency,
    required this.notifications,
    required this.privacy,
    required this.display,
    required this.searchHistoryEnabled,
    required this.locationServicesEnabled,
    required this.biometricEnabled,
    required this.syncedAt,
  });

  @override
  List<Object?> get props => [
        theme,
        language,
        currency,
        notifications,
        privacy,
        display,
        searchHistoryEnabled,
        locationServicesEnabled,
        biometricEnabled,
        syncedAt,
      ];

  AppSettings copyWith({
    String? theme,
    String? language,
    String? currency,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    DisplaySettings? display,
    bool? searchHistoryEnabled,
    bool? locationServicesEnabled,
    bool? biometricEnabled,
    DateTime? syncedAt,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      display: display ?? this.display,
      searchHistoryEnabled: searchHistoryEnabled ?? this.searchHistoryEnabled,
      locationServicesEnabled:
          locationServicesEnabled ?? this.locationServicesEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}

class NotificationSettings extends Equatable {
  final bool enabled;
  final bool sound;
  final bool vibration;

  const NotificationSettings({
    required this.enabled,
    required this.sound,
    required this.vibration,
  });

  @override
  List<Object?> get props => [enabled, sound, vibration];

  NotificationSettings copyWith({
    bool? enabled,
    bool? sound,
    bool? vibration,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
    );
  }
}

class PrivacySettings extends Equatable {
  final bool showOnlineStatus;
  final bool showLastSeen;

  const PrivacySettings({
    required this.showOnlineStatus,
    required this.showLastSeen,
  });

  @override
  List<Object?> get props => [showOnlineStatus, showLastSeen];

  PrivacySettings copyWith({
    bool? showOnlineStatus,
    bool? showLastSeen,
  }) {
    return PrivacySettings(
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showLastSeen: showLastSeen ?? this.showLastSeen,
    );
  }
}

class DisplaySettings extends Equatable {
  final String textSize; // small, medium, large
  final bool dataSaver;
  final bool autoPlayVideos;

  const DisplaySettings({
    required this.textSize,
    required this.dataSaver,
    required this.autoPlayVideos,
  });

  @override
  List<Object?> get props => [textSize, dataSaver, autoPlayVideos];

  DisplaySettings copyWith({
    String? textSize,
    bool? dataSaver,
    bool? autoPlayVideos,
  }) {
    return DisplaySettings(
      textSize: textSize ?? this.textSize,
      dataSaver: dataSaver ?? this.dataSaver,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
    );
  }
}
