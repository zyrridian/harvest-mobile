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
class NearbyFarmerData with _$NearbyFarmerData {
  const factory NearbyFarmerData({
    required String id,
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
    required String iconPath,
  }) = _NearbyFarmerData;

  factory NearbyFarmerData.fromJson(Map<String, dynamic> json) =>
      _$NearbyFarmerDataFromJson(json);
}
