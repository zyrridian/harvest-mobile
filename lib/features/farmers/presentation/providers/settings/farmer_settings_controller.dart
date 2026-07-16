import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_farmer_profile_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_delivery_settings_usecase.dart';
import '../farmer_dashboard_controller.dart';
import 'farmer_settings_state.dart';

part 'farmer_settings_controller.g.dart';

@riverpod
GetFarmerProfileUseCase getFarmerProfileUseCase(Ref ref) {
  return GetFarmerProfileUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
GetDeliverySettingsUseCase getDeliverySettingsUseCase(Ref ref) {
  return GetDeliverySettingsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmerSettingsController extends _$FarmerSettingsController {
  @override
  FarmerSettingsState build() {
    _fetchSettings();
    return const FarmerSettingsState.loading();
  }

  Future<void> _fetchSettings() async {
    state = const FarmerSettingsState.loading();
    
    final profileResult = await ref.read(getFarmerProfileUseCaseProvider).call();
    final deliveryResult = await ref.read(getDeliverySettingsUseCaseProvider).call();

    profileResult.fold(
      (failure) => state = FarmerSettingsState.error(failure.message),
      (profile) {
        deliveryResult.fold(
          (failure) => state = FarmerSettingsState.error(failure.message),
          (deliverySettings) {
            state = FarmerSettingsState.data(
              profile: profile,
              deliverySettings: deliverySettings,
            );
          },
        );
      },
    );
  }

  Future<void> refresh() async {
    await _fetchSettings();
  }
}
