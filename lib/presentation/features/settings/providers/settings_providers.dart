import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/remote/settings_remote_datasource.dart';
import '../../../../data/repositories/settings_repository_impl.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/usecases/settings/get_app_settings.dart';
import '../../../../domain/usecases/settings/update_app_settings.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Data source provider
final settingsDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSourceImpl(ref.watch(dioProvider));
});

// Repository provider
final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsDataSourceProvider));
});

// Use cases providers
final getAppSettingsUseCaseProvider = Provider<GetAppSettings>((ref) {
  return GetAppSettings(ref.watch(settingsRepositoryProvider));
});

final updateAppSettingsUseCaseProvider = Provider<UpdateAppSettings>((ref) {
  return UpdateAppSettings(ref.watch(settingsRepositoryProvider));
});

// State providers
final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final useCase = ref.watch(getAppSettingsUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (settings) => settings,
  );
});

// State notifier for settings management
class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final UpdateAppSettings updateUseCase;
  final GetAppSettings getUseCase;

  SettingsNotifier({
    required this.updateUseCase,
    required this.getUseCase,
  }) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    final result = await getUseCase();

    state = result.fold(
      (failure) => AsyncValue.error(
        _mapFailureToMessage(failure),
        StackTrace.current,
      ),
      (settings) => AsyncValue.data(settings),
    );
  }

  Future<void> updateTheme(String theme) async {
    await _updateSetting({'theme': theme});
  }

  Future<void> updateLanguage(String language) async {
    await _updateSetting({'language': language});
  }

  Future<void> updateNotificationSound(bool enabled) async {
    await _updateSetting({
      'notifications': {'sound': enabled}
    });
  }

  Future<void> updateNotificationVibration(bool enabled) async {
    await _updateSetting({
      'notifications': {'vibration': enabled}
    });
  }

  Future<void> updateTextSize(String size) async {
    await _updateSetting({
      'display': {'text_size': size}
    });
  }

  Future<void> updateDataSaver(bool enabled) async {
    await _updateSetting({
      'display': {'data_saver': enabled}
    });
  }

  Future<void> updateAutoPlayVideos(bool enabled) async {
    await _updateSetting({
      'display': {'auto_play_videos': enabled}
    });
  }

  Future<void> updateShowOnlineStatus(bool show) async {
    await _updateSetting({
      'privacy': {'show_online_status': show}
    });
  }

  Future<void> updateShowLastSeen(bool show) async {
    await _updateSetting({
      'privacy': {'show_last_seen': show}
    });
  }

  Future<void> updateBiometric(bool enabled) async {
    await _updateSetting({'biometric_enabled': enabled});
  }

  Future<void> updateLocationServices(bool enabled) async {
    await _updateSetting({'location_services_enabled': enabled});
  }

  Future<void> updateSearchHistory(bool enabled) async {
    await _updateSetting({'search_history_enabled': enabled});
  }

  Future<void> _updateSetting(Map<String, dynamic> updates) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    state = const AsyncValue.loading();
    final result = await updateUseCase(updates);

    state = result.fold(
      (failure) => AsyncValue.error(
        _mapFailureToMessage(failure),
        StackTrace.current,
      ),
      (settings) => AsyncValue.data(settings),
    );
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return SettingsNotifier(
    updateUseCase: ref.watch(updateAppSettingsUseCaseProvider),
    getUseCase: ref.watch(getAppSettingsUseCaseProvider),
  );
});

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure _:
      return 'Server error occurred';
    case CacheFailure _:
      return 'Cache error occurred';
    case NetworkFailure _:
      return 'Network error occurred';
    default:
      return 'Unexpected error occurred';
  }
}
