import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsModel {
  final String theme;
  final String language;
  final String currency;
  final NotificationSettingsModel notifications;
  final PrivacySettingsModel privacy;
  final DisplaySettingsModel display;
  @JsonKey(name: 'search_history_enabled')
  final bool searchHistoryEnabled;
  @JsonKey(name: 'location_services_enabled')
  final bool locationServicesEnabled;
  @JsonKey(name: 'biometric_enabled')
  final bool biometricEnabled;
  @JsonKey(name: 'synced_at')
  final String syncedAt;

  const AppSettingsModel({
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

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettings toEntity() {
    return AppSettings(
      theme: theme,
      language: language,
      currency: currency,
      notifications: notifications.toEntity(),
      privacy: privacy.toEntity(),
      display: display.toEntity(),
      searchHistoryEnabled: searchHistoryEnabled,
      locationServicesEnabled: locationServicesEnabled,
      biometricEnabled: biometricEnabled,
      syncedAt: DateTime.parse(syncedAt),
    );
  }

  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      theme: settings.theme,
      language: settings.language,
      currency: settings.currency,
      notifications:
          NotificationSettingsModel.fromEntity(settings.notifications),
      privacy: PrivacySettingsModel.fromEntity(settings.privacy),
      display: DisplaySettingsModel.fromEntity(settings.display),
      searchHistoryEnabled: settings.searchHistoryEnabled,
      locationServicesEnabled: settings.locationServicesEnabled,
      biometricEnabled: settings.biometricEnabled,
      syncedAt: settings.syncedAt.toIso8601String(),
    );
  }
}

@JsonSerializable()
class NotificationSettingsModel {
  final bool enabled;
  final bool sound;
  final bool vibration;

  const NotificationSettingsModel({
    required this.enabled,
    required this.sound,
    required this.vibration,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsModelToJson(this);

  NotificationSettings toEntity() {
    return NotificationSettings(
      enabled: enabled,
      sound: sound,
      vibration: vibration,
    );
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettings settings) {
    return NotificationSettingsModel(
      enabled: settings.enabled,
      sound: settings.sound,
      vibration: settings.vibration,
    );
  }
}

@JsonSerializable()
class PrivacySettingsModel {
  @JsonKey(name: 'show_online_status')
  final bool showOnlineStatus;
  @JsonKey(name: 'show_last_seen')
  final bool showLastSeen;

  const PrivacySettingsModel({
    required this.showOnlineStatus,
    required this.showLastSeen,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacySettingsModelToJson(this);

  PrivacySettings toEntity() {
    return PrivacySettings(
      showOnlineStatus: showOnlineStatus,
      showLastSeen: showLastSeen,
    );
  }

  factory PrivacySettingsModel.fromEntity(PrivacySettings settings) {
    return PrivacySettingsModel(
      showOnlineStatus: settings.showOnlineStatus,
      showLastSeen: settings.showLastSeen,
    );
  }
}

@JsonSerializable()
class DisplaySettingsModel {
  @JsonKey(name: 'text_size')
  final String textSize;
  @JsonKey(name: 'data_saver')
  final bool dataSaver;
  @JsonKey(name: 'auto_play_videos')
  final bool autoPlayVideos;

  const DisplaySettingsModel({
    required this.textSize,
    required this.dataSaver,
    required this.autoPlayVideos,
  });

  factory DisplaySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$DisplaySettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DisplaySettingsModelToJson(this);

  DisplaySettings toEntity() {
    return DisplaySettings(
      textSize: textSize,
      dataSaver: dataSaver,
      autoPlayVideos: autoPlayVideos,
    );
  }

  factory DisplaySettingsModel.fromEntity(DisplaySettings settings) {
    return DisplaySettingsModel(
      textSize: settings.textSize,
      dataSaver: settings.dataSaver,
      autoPlayVideos: settings.autoPlayVideos,
    );
  }
}
