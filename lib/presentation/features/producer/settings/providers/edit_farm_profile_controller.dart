import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/usecases/producer/update_farm_profile_usecase.dart';
import 'package:harvest_app/domain/entities/farm_profile_request.dart';
import '../../dashboard/providers/farmer_dashboard_controller.dart';
import 'farmer_settings_controller.dart';

part 'edit_farm_profile_controller.g.dart';

@riverpod
UpdateFarmProfileUseCase updateFarmProfileUseCase(Ref ref) {
  return UpdateFarmProfileUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class EditFarmProfileController extends _$EditFarmProfileController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateProfile(FarmProfileRequest request) async {
    state = const AsyncValue.loading();
    final result = await ref.read(updateFarmProfileUseCaseProvider).execute(request);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (profile) {
        state = const AsyncValue.data(null);
        // Refresh settings after successful update
        ref.read(farmerSettingsControllerProvider.notifier).refresh();
      },
    );
  }
}
