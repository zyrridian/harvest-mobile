import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_product_model.g.dart';

@JsonSerializable()
class CategoryProductModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String category;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(name: 'seller_id')
  final String sellerId;
  @JsonKey(name: 'seller_name')
  final String sellerName;
  final double price;
  final String currency;
  final String unit;
  final String? image;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  final List<String> images;
  @JsonKey(name: 'is_organic')
  final bool isOrganic;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  final double? discount;
  final double rating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  final FarmerModel farmer;
  @JsonKey(name: 'is_harvest')
  final bool isHarvest;
  @JsonKey(name: 'target_amount')
  final double? targetAmount;
  @JsonKey(name: 'current_booked')
  final double currentBooked;
  @JsonKey(name: 'harvest_date')
  final String? harvestDate;
  final List<String> tags;
  @JsonKey(name: 'created_at')
  final String createdAt;

  CategoryProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.category,
    required this.categoryId,
    required this.categoryName,
    required this.sellerId,
    required this.sellerName,
    required this.price,
    required this.currency,
    required this.unit,
    this.image,
    required this.imageUrl,
    required this.images,
    required this.isOrganic,
    required this.isAvailable,
    required this.stockQuantity,
    this.discount,
    required this.rating,
    required this.reviewCount,
    required this.farmer,
    required this.isHarvest,
    this.targetAmount,
    required this.currentBooked,
    this.harvestDate,
    required this.tags,
    required this.createdAt,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) => _$CategoryProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductModelToJson(this);

  CategoryProduct toEntity() {
    return CategoryProduct(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      sellerId: sellerId,
      sellerName: sellerName,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      isOrganic: isOrganic,
      stockQuantity: stockQuantity,
      discount: discount?.toString(),
    );
  }
}

@JsonSerializable()
class FarmerModel {
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  FarmerModel({
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) => _$FarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerModelToJson(this);
}
