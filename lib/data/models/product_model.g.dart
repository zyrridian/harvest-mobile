// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['image_url'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isOrganic: json['is_organic'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      stock: (json['stock'] as num).toInt(),
      discount: (json['discount'] as num?)?.toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      farmerId: json['farmer_id'] as String,
      farmerName: json['farmer_name'] as String,
      harvestDate: json['harvest_date'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'unit': instance.unit,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'is_organic': instance.isOrganic,
      'is_available': instance.isAvailable,
      'stock': instance.stock,
      'discount': instance.discount,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'farmer_id': instance.farmerId,
      'farmer_name': instance.farmerName,
      'harvest_date': instance.harvestDate,
      'tags': instance.tags,
      'created_at': instance.createdAt,
    };
