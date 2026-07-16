import 'package:harvest_app/features/farmers/domain/entities/farmer_gallery_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_gallery_image_model.g.dart';

@JsonSerializable()
class FarmerGalleryImageModel {
  final String id;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String? caption;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const FarmerGalleryImageModel({
    required this.id,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
  });

  factory FarmerGalleryImageModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerGalleryImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerGalleryImageModelToJson(this);

  FarmerGalleryImage toEntity() {
    return FarmerGalleryImage(
      id: id,
      imageUrl: imageUrl,
      caption: caption,
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory FarmerGalleryImageModel.fromEntity(FarmerGalleryImage entity) {
    return FarmerGalleryImageModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      caption: entity.caption,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
