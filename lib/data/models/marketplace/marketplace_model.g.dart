// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceModel _$MarketplaceModelFromJson(Map<String, dynamic> json) =>
    MarketplaceModel(
      flashHarvest: json['flash_harvest'] == null
          ? null
          : FlashHarvestModel.fromJson(
              json['flash_harvest'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>)
          .map((e) =>
              MarketplaceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>)
          .map((e) =>
              MarketplaceProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MarketplaceModelToJson(MarketplaceModel instance) =>
    <String, dynamic>{
      'flash_harvest': instance.flashHarvest?.toJson(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'products': instance.products.map((e) => e.toJson()).toList(),
    };

MarketplaceCategoryModel _$MarketplaceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    MarketplaceCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconPath: json['icon_path'] as String,
      gradientColors: (json['gradient_colors'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MarketplaceCategoryModelToJson(
        MarketplaceCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_path': instance.iconPath,
      'gradient_colors': instance.gradientColors,
    };

MarketplaceProductModel _$MarketplaceProductModelFromJson(
        Map<String, dynamic> json) =>
    MarketplaceProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      farmerName: json['farmer_name'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      soldCount: (json['sold_count'] as num).toInt(),
      isFresh: json['is_fresh'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );

Map<String, dynamic> _$MarketplaceProductModelToJson(
        MarketplaceProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'farmer_name': instance.farmerName,
      'price': instance.price,
      'unit': instance.unit,
      'image_url': instance.imageUrl,
      'rating': instance.rating,
      'sold_count': instance.soldCount,
      'is_fresh': instance.isFresh,
      'is_favorite': instance.isFavorite,
    };

FlashHarvestModel _$FlashHarvestModelFromJson(Map<String, dynamic> json) =>
    FlashHarvestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      distance: json['distance'] as String,
      imageUrl: json['image_url'] as String,
      isFavorite: json['is_favorite'] as bool,
    );

Map<String, dynamic> _$FlashHarvestModelToJson(FlashHarvestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'distance': instance.distance,
      'image_url': instance.imageUrl,
      'is_favorite': instance.isFavorite,
    };
