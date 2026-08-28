import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_farmer_profile_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_delivery_settings_usecase.dart';
import '../farmer_dashboard_controller.dart';
import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';
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
          (failure) {
            // If delivery settings haven't been configured yet (e.g., 404), use defaults
            state = FarmerSettingsState.data(
              profile: profile,
              deliverySettings: const DeliverySettings(
                farmerDeliveryEnabled: false,
                baseFee: 0,
                perKmRate: 0,
                maxRadiusKm: 0,
                minOrderForFree: 0,
                cashOnDeliveryEnabled: false,
              ),
            );
          },
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
