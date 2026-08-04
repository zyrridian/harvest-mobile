import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_farmer.freezed.dart';
part 'nearby_farmer.g.dart';

@freezed
class NearbyFarmerProduct with _$NearbyFarmerProduct {
  const factory NearbyFarmerProduct({
    required String name,
  }) = _NearbyFarmerProduct;

  factory NearbyFarmerProduct.fromJson(Map<String, dynamic> json) =>
      _$NearbyFarmerProductFromJson(json);
}

@freezed
class NearbyFarmerCabang with _$NearbyFarmerCabang {
  const factory NearbyFarmerCabang({
    required String id,
    required String name,
    String? description,
    String? whatWeSell,
    required double latitude,
    required double longitude,
    String? address,
    String? imageUrl,
    @Default(true) bool isActive,
    @Default([]) List<String> tags,
    String? operatingHours,
    double? distance,
  }) = _NearbyFarmerCabang;

  factory NearbyFarmerCabang.fromJson(Map<String, dynamic> json) =>
      _$NearbyFarmerCabangFromJson(json);
}

@freezed
class NearbyFarmerMainLocation with _$NearbyFarmerMainLocation {
  const factory NearbyFarmerMainLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? city,
    String? state,
  }) = _NearbyFarmerMainLocation;

  factory NearbyFarmerMainLocation.fromJson(Map<String, dynamic> json) =>
      _$NearbyFarmerMainLocationFromJson(json);
}

@freezed
class NearbyFarmerData with _$NearbyFarmerData {
  const factory NearbyFarmerData({
    required String id,
    String? userId,
    required String name,
    required double distance,
    required String category,
    required String subCategory,
    required double rating,
    required int reviewCount,
    required List<String> tags,
    required List<NearbyFarmerProduct> products,
    required int extraProductsCount,
    required String statusText,
    required String statusSubText,
    required bool isOpen,
    required double latitude,
    required double longitude,
    String? iconPath,
    NearbyFarmerMainLocation? mainLocation,
    @Default([]) List<NearbyFarmerCabang> cabang,
  }) = _NearbyFarmerData;

  factory NearbyFarmerData.fromJson(Map<String, dynamic> json) =>
      _$NearbyFarmerDataFromJson(json);
}
