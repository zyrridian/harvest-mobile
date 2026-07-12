import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';

part 'marketplace_state.freezed.dart';

class ProductFilterParams {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final bool? isOrganic;
  final String? sortBy;
  final String? order;

  const ProductFilterParams({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.isOrganic,
    this.sortBy,
    this.order,
  });

  ProductFilterParams copyWith({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? isOrganic,
    String? sortBy,
    String? order,
  }) {
    return ProductFilterParams(
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      isOrganic: isOrganic ?? this.isOrganic,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  bool get isEmpty =>
      categoryId == null &&
      minPrice == null &&
      maxPrice == null &&
      isOrganic == null &&
      sortBy == null &&
      order == null;
}

class MarketplaceData {
  final FlashHarvest? flashHarvest;
  final List<MarketplaceCategory> categories;
  final List<MarketplaceProduct> products;
  final ProductFilterParams filterParams;
  final int cartItemCount;
  final double cartTotal;
  final bool isRefetching;

  MarketplaceData({
    this.flashHarvest,
    required this.categories,
    required this.products,
    this.filterParams = const ProductFilterParams(),
    this.cartItemCount = 0,
    this.cartTotal = 0.0,
    this.isRefetching = false,
  });

  factory MarketplaceData.fromResponseEntity(
    MarketplaceResponseEntity entity, {
    ProductFilterParams filterParams = const ProductFilterParams(),
    int cartItemCount = 0,
    double cartTotal = 0.0,
  }) {
    return MarketplaceData(
      flashHarvest: entity.flashHarvest,
      categories: entity.categories,
      products: entity.products,
      filterParams: filterParams,
      cartItemCount: cartItemCount,
      cartTotal: cartTotal,
    );
  }

  MarketplaceData copyWith({
    FlashHarvest? flashHarvest,
    List<MarketplaceCategory>? categories,
    List<MarketplaceProduct>? products,
    ProductFilterParams? filterParams,
    int? cartItemCount,
    double? cartTotal,
    bool? isRefetching,
  }) {
    return MarketplaceData(
      flashHarvest: flashHarvest ?? this.flashHarvest,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      filterParams: filterParams ?? this.filterParams,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      cartTotal: cartTotal ?? this.cartTotal,
      isRefetching: isRefetching ?? this.isRefetching,
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
