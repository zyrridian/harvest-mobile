import 'package:dio/dio.dart';
import '../../models/app_settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<AppSettingsModel> getAppSettings();
  Future<AppSettingsModel> updateAppSettings(Map<String, dynamic> updates);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio dio;

  SettingsRemoteDataSourceImpl(this.dio);

  @override
  Future<AppSettingsModel> getAppSettings() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      'status': 'success',
      'data': {
        'settings': {
          'theme': 'light',
          'language': 'en',
          'currency': 'IDR',
          'notifications': {
            'enabled': true,
            'sound': true,
            'vibration': true,
          },
          'privacy': {
            'show_online_status': true,
            'show_last_seen': true,
          },
          'display': {
            'text_size': 'medium',
            'data_saver': false,
            'auto_play_videos': true,
          },
          'search_history_enabled': true,
          'location_services_enabled': true,
          'biometric_enabled': false,
          'synced_at': DateTime.now().toIso8601String(),
        },
      },
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    final settings = data['settings'] as Map<String, dynamic>;
    return AppSettingsModel.fromJson(settings);
  }

  @override
  Future<AppSettingsModel> updateAppSettings(
      Map<String, dynamic> updates) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Get current settings
    final currentSettings = await getAppSettings();
    final currentJson = currentSettings.toJson();

    // Merge updates
    final updatedJson = _deepMerge(currentJson, updates);
    updatedJson['synced_at'] = DateTime.now().toIso8601String();

    return AppSettingsModel.fromJson(updatedJson);
  }

  Map<String, dynamic> _deepMerge(
      Map<String, dynamic> target, Map<String, dynamic> source) {
    final result = Map<String, dynamic>.from(target);

    source.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          result[key] is Map<String, dynamic>) {
        result[key] = _deepMerge(result[key], value);
      } else {
        result[key] = value;
      }
    });

    return result;
  }
}
