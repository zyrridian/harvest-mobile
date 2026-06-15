import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_state.freezed.dart';

class MarketplaceCategory {
  final String id;
  final String name;
  final String iconPath;
  final List<int> gradientColors;

  MarketplaceCategory({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.gradientColors,
  });
}

class MarketplaceProduct {
  final String id;
  final String name;
  final String farmerName;
  final double price;
  final String unit;
  final String imageUrl;
  final double rating;
  final int soldCount;
  final bool isFresh;

  MarketplaceProduct({
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
}

class FlashHarvest {
  final String id;
  final String title;
  final String subtitle;
  final String distance;
  final String imageUrl;

  FlashHarvest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.imageUrl,
  });
}

class MarketplaceData {
  final FlashHarvest? flashHarvest;
  final List<MarketplaceCategory> categories;
  final List<MarketplaceProduct> products;

  MarketplaceData({
    this.flashHarvest,
    required this.categories,
    required this.products,
  });
}

@freezed
class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState.initial() = _Initial;
  const factory MarketplaceState.loading() = _Loading;
  const factory MarketplaceState.data(MarketplaceData data) = _Data;
  const factory MarketplaceState.error(String message) = _Error;
}
