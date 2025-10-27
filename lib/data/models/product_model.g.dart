// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      storeName: json['store_name'] as String,
      storeId: json['store_id'] as String,
      distance: (json['distance'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      rating: (json['rating'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      tag: json['tag'] as String?,
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'store_name': instance.storeName,
      'store_id': instance.storeId,
      'distance': instance.distance,
      'price': instance.price,
      'unit': instance.unit,
      'rating': instance.rating,
      'stock': instance.stock,
      'tag': instance.tag,
      'image_url': instance.imageUrl,
      'category': instance.category,
      'types': instance.types,
      'created_at': instance.createdAt,
    };
