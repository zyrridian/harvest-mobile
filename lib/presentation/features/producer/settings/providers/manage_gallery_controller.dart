import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/farmer_gallery_image.dart';
import 'package:harvest_app/domain/usecases/farmers/add_farmer_gallery_image.dart';
import 'package:harvest_app/domain/usecases/farmers/delete_farmer_gallery_image.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmers_controller.dart';
import 'package:harvest_app/presentation/providers/utility_providers.dart';

part 'manage_gallery_controller.g.dart';

@riverpod
class ManageGalleryController extends _$ManageGalleryController {
  @override
  FutureOr<List<FarmerGalleryImage>> build() async {
    return _fetchGallery();
  }

  Future<List<FarmerGalleryImage>> _fetchGallery() async {
    final getFarmerGalleryUseCase = ref.read(getFarmerGalleryUseCaseProvider);
    final result = await getFarmerGalleryUseCase();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (gallery) => gallery,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchGallery());
  }

  Future<void> addImage(File imageFile, {String? caption}) async {
    // 1. Upload the file to get the URL
    final uploadFileUseCase = ref.read(uploadFileUseCaseProvider);
    final uploadResult = await uploadFileUseCase(imageFile);
    
    uploadResult.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (uploadedFile) async {
        // 2. Add the URL to the gallery
        final addGalleryImageUseCase = ref.read(addFarmerGalleryImageUseCaseProvider);
        final result = await addGalleryImageUseCase(uploadedFile.url, caption: caption);
        
        result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (newImage) {
            if (state.hasValue) {
              final currentList = state.value!;
              state = AsyncValue.data([...currentList, newImage]);
            } else {
              refresh();
            }
          },
        );
      },
    );
  }

  Future<void> deleteImage(String imageId) async {
    final deleteGalleryImageUseCase = ref.read(deleteFarmerGalleryImageUseCaseProvider);
    final result = await deleteGalleryImageUseCase(imageId);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        if (state.hasValue) {
          final currentList = state.value!;
          state = AsyncValue.data(
            currentList.where((img) => img.id != imageId).toList(),
          );
        }
      },
    );
  }
}
