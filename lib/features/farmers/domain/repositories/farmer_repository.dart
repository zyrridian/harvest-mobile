import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/farmer.dart';
import '../entities/farmer_detail.dart';
import '../entities/farmer_gallery_image.dart';
import '../../../../core/models/paginated_response.dart';

abstract class FarmerRepository {
  Future<Either<Failure, PaginatedResponse<Farmer>>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
    int? limit,
    int? page,
    String? sortBy,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, Farmer>> getFarmerById(String id);

  Future<Either<Failure, FarmerDetail>> getFarmerDetailById(String id);

  Future<Either<Failure, PaginatedResponse<Farmer>>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0, // in km
    int? limit,
    int? page,
  });

  Future<Either<Failure, void>> followFarmer(String id);
  Future<Either<Failure, void>> unfollowFarmer(String id);
  Future<Either<Failure, List<FarmerGalleryImage>>> getFarmerGallery();
  Future<Either<Failure, FarmerGalleryImage>> addGalleryImage(String imageUrl, {String? caption});
  Future<Either<Failure, void>> deleteGalleryImage(String id);
}
