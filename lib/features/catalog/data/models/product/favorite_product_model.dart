import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/favorite_product.dart';

part 'favorite_product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteProductModel {
  final String id;
  @JsonKey(name: 'product_id')
  final String productId;
  final String name;
  final double price;
  final String unit;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @JsonKey(name: 'is_fresh')
  final bool isFresh;
  final double rating;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  FavoriteProductModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.farmerName,
    required this.isFresh,
    required this.rating,
    required this.createdAt,
  });

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) => _$FavoriteProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteProductModelToJson(this);

  FavoriteProduct toEntity() => FavoriteProduct(
        id: id,
        productId: productId,
        name: name,
        price: price,
        unit: unit,
        imageUrl: imageUrl,
        farmerName: farmerName,
        isFresh: isFresh,
        rating: rating,
        createdAt: createdAt,
      );
}

@JsonSerializable(explicitToJson: true)
class FavoriteProductListModel {
  final List<FavoriteProductModel> favorites;
  final int total;

  FavoriteProductListModel({
    required this.favorites,
    required this.total,
  });

  factory FavoriteProductListModel.fromJson(Map<String, dynamic> json) => _$FavoriteProductListModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteProductListModelToJson(this);

  FavoriteProductList toEntity() => FavoriteProductList(
        favorites: favorites.map((e) => e.toEntity()).toList(),
        total: total,
      );
}
