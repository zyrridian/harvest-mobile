// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_gallery_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerGalleryImageModel _$FarmerGalleryImageModelFromJson(
        Map<String, dynamic> json) =>
    FarmerGalleryImageModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      caption: json['caption'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$FarmerGalleryImageModelToJson(
        FarmerGalleryImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_url': instance.imageUrl,
      'caption': instance.caption,
      'created_at': instance.createdAt,
    };
