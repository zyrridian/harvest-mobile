// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteProductModel _$FavoriteProductModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteProductModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['image_url'] as String,
      farmerName: json['farmer_name'] as String,
      isFresh: json['is_fresh'] as bool,
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FavoriteProductModelToJson(
        FavoriteProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'unit': instance.unit,
      'image_url': instance.imageUrl,
      'farmer_name': instance.farmerName,
      'is_fresh': instance.isFresh,
      'rating': instance.rating,
      'created_at': instance.createdAt.toIso8601String(),
    };

FavoriteProductListModel _$FavoriteProductListModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteProductListModel(
      favorites: (json['favorites'] as List<dynamic>)
          .map((e) => FavoriteProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$FavoriteProductListModelToJson(
        FavoriteProductListModel instance) =>
    <String, dynamic>{
      'favorites': instance.favorites.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
