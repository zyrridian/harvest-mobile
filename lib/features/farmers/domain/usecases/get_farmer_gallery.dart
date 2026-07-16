import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/farmer_gallery_image.dart';
import '../repositories/farmer_repository.dart';

class GetFarmerGalleryUseCase {
  final FarmerRepository repository;

  GetFarmerGalleryUseCase(this.repository);

  Future<Either<Failure, List<FarmerGalleryImage>>> call() async {
    return await repository.getFarmerGallery();
  }
}
