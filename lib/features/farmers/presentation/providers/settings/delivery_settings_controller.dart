import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmer_dashboard_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/delivery_settings.dart';
import 'package:harvest_app/domain/usecases/producer/update_delivery_settings_usecase.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/farmer_settings_controller.dart';

part 'delivery_settings_controller.g.dart';

@riverpod
UpdateDeliverySettingsUseCase updateDeliverySettingsUseCase(Ref ref) {
  return UpdateDeliverySettingsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class DeliverySettingsController extends _$DeliverySettingsController {
  @override
  AsyncValue<DeliverySettings?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateSettings(DeliverySettings settings) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateDeliverySettingsUseCaseProvider).call(settings);
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (updatedSettings) {
        state = AsyncValue.data(updatedSettings);
        ref.read(farmerSettingsControllerProvider.notifier).refresh();
      },
    );
  }
}
