import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmers_controller.dart';
import '../../../core/error/failure.dart';
import '../../repositories/farmer_repository.dart';
import '../../entities/farmer_gallery_image.dart';

final addFarmerGalleryImageUseCaseProvider = Provider<AddFarmerGalleryImageUseCase>((ref) {
  return AddFarmerGalleryImageUseCase(ref.read(farmerRepositoryProvider));
});

class AddFarmerGalleryImageUseCase {
  final FarmerRepository repository;

  AddFarmerGalleryImageUseCase(this.repository);

  Future<Either<Failure, FarmerGalleryImage>> call(String imageUrl, {String? caption}) async {
    return await repository.addGalleryImage(imageUrl, caption: caption);
  }
}
