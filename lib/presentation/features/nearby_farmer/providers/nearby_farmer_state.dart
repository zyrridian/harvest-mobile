import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_farmer_state.freezed.dart';

class NearbyFarmerProduct {
  final String name;
  NearbyFarmerProduct({required this.name});
}

class NearbyFarmerData {
  final String id;
  final String name;
  final double distance;
  final String category;
  final String subCategory;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final List<NearbyFarmerProduct> products;
  final int extraProductsCount;
  final String statusText;
  final String statusSubText;
  final bool isOpen;
  final double latitude;
  final double longitude;
  final String iconPath;

  NearbyFarmerData({
    required this.id,
    required this.name,
    required this.distance,
    required this.category,
    required this.subCategory,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.products,
    required this.extraProductsCount,
    required this.statusText,
    required this.statusSubText,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    required this.iconPath,
  });
}

@freezed
class NearbyFarmerState with _$NearbyFarmerState {
  const factory NearbyFarmerState.initial() = _Initial;
  const factory NearbyFarmerState.loading() = _Loading;
  const factory NearbyFarmerState.data({
    required List<NearbyFarmerData> farmers,
    @Default('') String searchQuery,
    @Default(false) bool isOrganicFilter,
    @Default(false) bool isOpenNowFilter,
  }) = _Data;
  const factory NearbyFarmerState.error(String message) = _Error;
}
