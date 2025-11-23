import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String unit;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final List<String> images;
  @JsonKey(name: 'is_organic')
  final bool isOrganic;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  final int stock;
  final double? discount;
  final double rating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @JsonKey(name: 'farmer_id')
  final String farmerId;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @JsonKey(name: 'harvest_date')
  final String? harvestDate;
  final List<String> tags;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.images = const [],
    this.isOrganic = false,
    this.isAvailable = true,
    required this.stock,
    this.discount,
    required this.rating,
    required this.reviewCount,
    required this.farmerId,
    required this.farmerName,
    this.harvestDate,
    this.tags = const [],
    required this.createdAt,
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
      price: price,
      unit: unit,
      imageUrl: imageUrl,
      images: images,
      isOrganic: isOrganic,
      isAvailable: isAvailable,
      stock: stock,
      discount: discount,
      rating: rating,
      reviewCount: reviewCount,
      farmerId: farmerId,
      farmerName: farmerName,
      harvestDate: harvestDate != null ? DateTime.parse(harvestDate!) : null,
      tags: tags,
      createdAt: DateTime.parse(createdAt),
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
      createdAt: product.createdAt.toIso8601String(),
    );
  }
}
