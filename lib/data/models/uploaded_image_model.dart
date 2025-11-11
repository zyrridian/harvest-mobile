import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/uploaded_image.dart';

part 'uploaded_image_model.g.dart';

@JsonSerializable()
class UploadedImageModel {
  @JsonKey(name: 'image_id')
  final String imageId;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'medium_url')
  final String mediumUrl;
  final int size;
  final int width;
  final int height;
  final String format;
  @JsonKey(name: 'uploaded_at')
  final String uploadedAt;

  const UploadedImageModel({
    required this.imageId,
    required this.url,
    required this.thumbnailUrl,
    required this.mediumUrl,
    required this.size,
    required this.width,
    required this.height,
    required this.format,
    required this.uploadedAt,
  });

  factory UploadedImageModel.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedImageModelToJson(this);

  UploadedImage toEntity() {
    return UploadedImage(
      imageId: imageId,
      url: url,
      thumbnailUrl: thumbnailUrl,
      mediumUrl: mediumUrl,
      size: size,
      width: width,
      height: height,
      format: format,
      uploadedAt: DateTime.parse(uploadedAt),
    );
  }

  factory UploadedImageModel.fromEntity(UploadedImage entity) {
    return UploadedImageModel(
      imageId: entity.imageId,
      url: entity.url,
      thumbnailUrl: entity.thumbnailUrl,
      mediumUrl: entity.mediumUrl,
      size: entity.size,
      width: entity.width,
      height: entity.height,
      format: entity.format,
      uploadedAt: entity.uploadedAt.toIso8601String(),
    );
  }
}
