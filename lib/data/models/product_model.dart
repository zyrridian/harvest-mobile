import 'package:json_annotation/json_annotation.dart';
import '../../features/catalog/domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double? price;
  final String unit;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(defaultValue: [])
  final List<String> images;
  @JsonKey(name: 'is_organic')
  final bool isOrganic;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  final int? stock;
  final double? discount;
  final double? rating;
  @JsonKey(name: 'review_count')
  final int? reviewCount;
  @JsonKey(name: 'farmer_id')
  final String? farmerId;
  @JsonKey(name: 'farmer_name')
  final String? farmerName;
  @JsonKey(name: 'harvest_date')
  final String? harvestDate;
  @JsonKey(defaultValue: [])
  final List<String> tags;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.price,
    required this.unit,
    required this.imageUrl,
    this.images = const [],
    this.isOrganic = false,
    this.isAvailable = true,
    this.stock,
    this.discount,
    this.rating,
    this.reviewCount,
    this.farmerId,
    this.farmerName,
    this.harvestDate,
    this.tags = const [],
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price ?? 0.0,
      unit: unit,
      imageUrl: imageUrl,
      images: images,
      isOrganic: isOrganic,
      isAvailable: isAvailable,
      stock: stock ?? 0,
      discount: discount,
      rating: rating ?? 0.0,
      reviewCount: reviewCount ?? 0,
      farmerId: farmerId,
      farmerName: farmerName,
      harvestDate: harvestDate != null ? DateTime.parse(harvestDate!) : null,
      tags: tags,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      category: product.category,
      price: product.price,
      unit: product.unit,
      imageUrl: product.imageUrl,
      images: product.images,
      isOrganic: product.isOrganic,
      isAvailable: product.isAvailable,
      stock: product.stock,
      discount: product.discount,
      rating: product.rating,
      reviewCount: product.reviewCount,
      farmerId: product.farmerId,
      farmerName: product.farmerName,
      harvestDate: product.harvestDate?.toIso8601String(),
      tags: product.tags,
      createdAt: product.createdAt?.toIso8601String(),
    );
  }
}
