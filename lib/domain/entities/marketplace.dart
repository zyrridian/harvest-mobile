import 'package:equatable/equatable.dart';

class MarketplaceCategory extends Equatable {
  final String id;
  final String name;
  final String iconPath;
  final List<int> gradientColors;

  const MarketplaceCategory({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.gradientColors,
  });

  @override
  List<Object?> get props => [id, name, iconPath, gradientColors];
}

class MarketplaceProduct extends Equatable {
  final String id;
  final String name;
  final String farmerName;
  final double price;
  final String unit;
  final String imageUrl;
  final double rating;
  final int soldCount;
  final bool isFresh;

  const MarketplaceProduct({
    required this.id,
    required this.name,
    required this.farmerName,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.rating,
    required this.soldCount,
    this.isFresh = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        farmerName,
        price,
        unit,
        imageUrl,
        rating,
        soldCount,
        isFresh,
      ];
}

class FlashHarvest extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String distance;
  final String imageUrl;

  const FlashHarvest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, subtitle, distance, imageUrl];
}

class MarketplaceResponseEntity extends Equatable {
  final FlashHarvest? flashHarvest;
  final List<MarketplaceCategory> categories;
  final List<MarketplaceProduct> products;

  const MarketplaceResponseEntity({
    this.flashHarvest,
    required this.categories,
    required this.products,
  });

  @override
  List<Object?> get props => [flashHarvest, categories, products];
}
