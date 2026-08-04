import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_product_model.g.dart';

@JsonSerializable()
class FarmerProductResponseModel {
  final String status;
  final List<FarmerProductModel> data;

  FarmerProductResponseModel({
    required this.status,
    required this.data,
  });

  factory FarmerProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerProductResponseModelToJson(this);
}

@JsonSerializable()
class FarmerProductModel {
  final String id;
  final String name;
  final num price;
  final String unit;
  final int stock;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'orders_count')
  final int? ordersCount;

  FarmerProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.stock,
    required this.isAvailable,
    this.imageUrl,
    this.ordersCount,
  });

  factory FarmerProductModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerProductModelToJson(this);

  FarmerProduct toEntity() {
    return FarmerProduct(
      id: id,
      name: name,
      price: price.toDouble(),
      unit: unit,
      stock: stock,
      isAvailable: isAvailable,
      imageUrl: imageUrl ?? 'https://picsum.photos/400/400',
      ordersCount: ordersCount ?? 0,
    );
  }
}
