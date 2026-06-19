import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';

part 'marketplace_state.freezed.dart';

class MarketplaceData {
  final FlashHarvest? flashHarvest;
  final List<MarketplaceCategory> categories;
  final List<MarketplaceProduct> products;
  final String selectedFilter;
  final int cartItemCount;
  final double cartTotal;

  MarketplaceData({
    this.flashHarvest,
    required this.categories,
    required this.products,
    this.selectedFilter = 'All',
    this.cartItemCount = 0,
    this.cartTotal = 0.0,
  });

  factory MarketplaceData.fromResponseEntity(
    MarketplaceResponseEntity entity, {
    String selectedFilter = 'All',
    int cartItemCount = 0,
    double cartTotal = 0.0,
  }) {
    return MarketplaceData(
      flashHarvest: entity.flashHarvest,
      categories: entity.categories,
      products: entity.products,
      selectedFilter: selectedFilter,
      cartItemCount: cartItemCount,
      cartTotal: cartTotal,
    );
  }

  MarketplaceData copyWith({
    FlashHarvest? flashHarvest,
    List<MarketplaceCategory>? categories,
    List<MarketplaceProduct>? products,
    String? selectedFilter,
    int? cartItemCount,
    double? cartTotal,
  }) {
    return MarketplaceData(
      flashHarvest: flashHarvest ?? this.flashHarvest,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      cartTotal: cartTotal ?? this.cartTotal,
    );
  }
}

@freezed
class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState.initial() = _Initial;
  const factory MarketplaceState.loading() = _Loading;
  const factory MarketplaceState.data(MarketplaceData data) = _Data;
  const factory MarketplaceState.error(String message) = _Error;
}
