import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/farmers/domain/usecases/update_farm_profile_usecase.dart';
import 'package:harvest_app/domain/entities/farm_profile_request.dart';
import 'package:harvest_app/features/system/presentation/providers/utility_providers.dart';
import '../farmer_dashboard_controller.dart';
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

    String? finalProfileImage = request.profileImage;
    String? finalCoverImage = request.coverImage;

    try {
      if (finalProfileImage != null && !finalProfileImage.startsWith('http')) {
        final uploadResult = await ref.read(uploadFileUseCaseProvider).call(File(finalProfileImage));
        uploadResult.fold(
          (failure) => throw Exception(failure.message),
          (uploadedFile) => finalProfileImage = uploadedFile.url,
        );
      }

      if (finalCoverImage != null && !finalCoverImage.startsWith('http')) {
        final uploadResult = await ref.read(uploadFileUseCaseProvider).call(File(finalCoverImage));
        uploadResult.fold(
          (failure) => throw Exception(failure.message),
          (uploadedFile) => finalCoverImage = uploadedFile.url,
        );
      }
    } catch (e) {
      state = AsyncValue.error('Failed to upload image: $e', StackTrace.current);
      return;
    }

    final finalRequest = FarmProfileRequest(
      name: request.name,
      description: request.description,
      profileImage: finalProfileImage,
      coverImage: finalCoverImage,
      address: request.address,
      city: request.city,
      state: request.state,
      latitude: request.latitude,
      longitude: request.longitude,
      phoneNumber: request.phoneNumber,
      specialties: request.specialties,
    );

    final result = await ref.read(updateFarmProfileUseCaseProvider).execute(finalRequest);

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
