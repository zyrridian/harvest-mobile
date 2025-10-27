import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'store_name')
  final String storeName;
  @JsonKey(name: 'store_id')
  final String storeId;
  final double distance;
  final double price;
  final String unit;
  final double rating;
  final int stock;
  final String? tag;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final String category;
  final List<String> types;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.storeName,
    required this.storeId,
    required this.distance,
    required this.price,
    required this.unit,
    required this.rating,
    required this.stock,
    this.tag,
    required this.imageUrl,
    required this.category,
    required this.types,
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
      storeName: storeName,
      storeId: storeId,
      distance: distance,
      price: price,
      unit: unit,
      rating: rating,
      stock: stock,
      tag: tag,
      imageUrl: imageUrl,
      category: category,
      types: types,
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      storeName: product.storeName,
      storeId: product.storeId,
      distance: product.distance,
      price: product.price,
      unit: product.unit,
      rating: product.rating,
      stock: product.stock,
      tag: product.tag,
      imageUrl: product.imageUrl,
      category: product.category,
      types: product.types,
      createdAt: product.createdAt.toIso8601String(),
    );
  }
}
