import 'package:harvest_app/features/storefront/domain/entities/marketplace.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marketplace_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MarketplaceModel {
  @JsonKey(name: 'flash_harvest')
  final FlashHarvestModel? flashHarvest;
  final List<MarketplaceCategoryModel> categories;
  final List<MarketplaceProductModel> products;

  MarketplaceModel({
    this.flashHarvest,
    required this.categories,
    required this.products,
  });

  factory MarketplaceModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceModelToJson(this);

  MarketplaceResponseEntity toEntity() {
    return MarketplaceResponseEntity(
      flashHarvest: flashHarvest?.toEntity(),
      categories: categories.map((e) => e.toEntity()).toList(),
      products: products.map((e) => e.toEntity()).toList(),
    );
  }

  factory MarketplaceModel.fromEntity(MarketplaceResponseEntity data) {
    return MarketplaceModel(
      flashHarvest: data.flashHarvest != null
          ? FlashHarvestModel.fromEntity(data.flashHarvest!)
          : null,
      categories: data.categories
          .map((e) => MarketplaceCategoryModel.fromEntity(e))
          .toList(),
      products: data.products
          .map((e) => MarketplaceProductModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class MarketplaceCategoryModel {
  final String id;
  final String name;
  @JsonKey(name: 'icon_path')
  final String iconPath;
  @JsonKey(name: 'gradient_colors')
  final List<int> gradientColors;

  MarketplaceCategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.gradientColors,
  });

  factory MarketplaceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceCategoryModelToJson(this);

  MarketplaceCategory toEntity() {
    return MarketplaceCategory(
      id: id,
      name: name,
      iconPath: iconPath,
      gradientColors: gradientColors,
    );
  }

  factory MarketplaceCategoryModel.fromEntity(MarketplaceCategory category) {
    return MarketplaceCategoryModel(
      id: category.id,
      name: category.name,
      iconPath: category.iconPath,
      gradientColors: category.gradientColors,
    );
  }
}

@JsonSerializable()
class MarketplaceProductModel {
  final String id;
  final String name;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  final double price;
  final String unit;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final double rating;
  @JsonKey(name: 'sold_count')
  final int soldCount;
  @JsonKey(name: 'is_fresh')
  final bool isFresh;
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  MarketplaceProductModel({
    required this.id,
    required this.name,
    required this.farmerName,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.rating,
    required this.soldCount,
    this.isFresh = false,
    this.isFavorite = false,
  });

  factory MarketplaceProductModel.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceProductModelToJson(this);

  MarketplaceProduct toEntity() {
    return MarketplaceProduct(
      id: id,
      name: name,
      farmerName: farmerName,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
      rating: rating,
      soldCount: soldCount,
      isFresh: isFresh,
      isFavorite: isFavorite,
    );
  }

  factory MarketplaceProductModel.fromEntity(MarketplaceProduct product) {
    return MarketplaceProductModel(
      id: product.id,
      name: product.name,
      farmerName: product.farmerName,
      price: product.price,
      unit: product.unit,
      imageUrl: product.imageUrl,
      rating: product.rating,
      soldCount: product.soldCount,
      isFresh: product.isFresh,
      isFavorite: product.isFavorite,
    );
  }
}

@JsonSerializable()
class FlashHarvestModel {
  final String id;
  final String title;
  final String subtitle;
  final String distance;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  FlashHarvestModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory FlashHarvestModel.fromJson(Map<String, dynamic> json) =>
      _$FlashHarvestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashHarvestModelToJson(this);

  FlashHarvest toEntity() {
    return FlashHarvest(
      id: id,
      title: title,
      subtitle: subtitle,
      distance: distance,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
  }

  factory FlashHarvestModel.fromEntity(FlashHarvest flashHarvest) {
    return FlashHarvestModel(
      id: flashHarvest.id,
      title: flashHarvest.title,
      subtitle: flashHarvest.subtitle,
      distance: flashHarvest.distance,
      imageUrl: flashHarvest.imageUrl,
      isFavorite: flashHarvest.isFavorite,
    );
  }
}
