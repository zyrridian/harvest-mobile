// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      theme: json['theme'] as String,
      language: json['language'] as String,
      currency: json['currency'] as String,
      notifications: NotificationSettingsModel.fromJson(
          json['notifications'] as Map<String, dynamic>),
      privacy: PrivacySettingsModel.fromJson(
          json['privacy'] as Map<String, dynamic>),
      display: DisplaySettingsModel.fromJson(
          json['display'] as Map<String, dynamic>),
      searchHistoryEnabled: json['search_history_enabled'] as bool,
      locationServicesEnabled: json['location_services_enabled'] as bool,
      biometricEnabled: json['biometric_enabled'] as bool,
      syncedAt: json['synced_at'] as String,
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
      'currency': instance.currency,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
      'display': instance.display,
      'search_history_enabled': instance.searchHistoryEnabled,
      'location_services_enabled': instance.locationServicesEnabled,
      'biometric_enabled': instance.biometricEnabled,
      'synced_at': instance.syncedAt,
    };

NotificationSettingsModel _$NotificationSettingsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsModel(
      enabled: json['enabled'] as bool,
      sound: json['sound'] as bool,
      vibration: json['vibration'] as bool,
    );

Map<String, dynamic> _$NotificationSettingsModelToJson(
        NotificationSettingsModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'sound': instance.sound,
      'vibration': instance.vibration,
    };

PrivacySettingsModel _$PrivacySettingsModelFromJson(
        Map<String, dynamic> json) =>
    PrivacySettingsModel(
      showOnlineStatus: json['show_online_status'] as bool,
      showLastSeen: json['show_last_seen'] as bool,
    );

Map<String, dynamic> _$PrivacySettingsModelToJson(
        PrivacySettingsModel instance) =>
    <String, dynamic>{
      'show_online_status': instance.showOnlineStatus,
      'show_last_seen': instance.showLastSeen,
    };

DisplaySettingsModel _$DisplaySettingsModelFromJson(
        Map<String, dynamic> json) =>
    DisplaySettingsModel(
      textSize: json['text_size'] as String,
      dataSaver: json['data_saver'] as bool,
      autoPlayVideos: json['auto_play_videos'] as bool,
    );

Map<String, dynamic> _$DisplaySettingsModelToJson(
        DisplaySettingsModel instance) =>
    <String, dynamic>{
      'text_size': instance.textSize,
      'data_saver': instance.dataSaver,
      'auto_play_videos': instance.autoPlayVideos,
    };
