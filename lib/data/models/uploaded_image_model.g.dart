// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadedImageModel _$UploadedImageModelFromJson(Map<String, dynamic> json) =>
    UploadedImageModel(
      imageId: json['image_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      mediumUrl: json['medium_url'] as String,
      size: (json['size'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      format: json['format'] as String,
      uploadedAt: json['uploaded_at'] as String,
    );

Map<String, dynamic> _$UploadedImageModelToJson(UploadedImageModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'medium_url': instance.mediumUrl,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
      'format': instance.format,
      'uploaded_at': instance.uploadedAt,
    };
