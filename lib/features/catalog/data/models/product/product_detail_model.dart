import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/product_detail.dart';

part 'product_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductDetailModel {
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
  final ProductFarmerModel farmer;
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

  ProductDetailModel({
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);

  ProductDetail toEntity() {
    return ProductDetail(
      id: id,
      name: name,
      slug: slug,
      description: description,
      category: category,
      categoryId: categoryId,
      categoryName: categoryName,
      sellerId: sellerId,
      sellerName: sellerName,
      price: price,
      currency: currency,
      unit: unit,
      image: image,
      imageUrl: imageUrl,
      images: images,
      isOrganic: isOrganic,
      isAvailable: isAvailable,
      stockQuantity: stockQuantity,
      discount: discount,
      rating: rating,
      reviewCount: reviewCount,
      farmer: farmer.toEntity(),
      isHarvest: isHarvest,
      targetAmount: targetAmount,
      currentBooked: currentBooked,
      harvestDate: harvestDate != null ? DateTime.tryParse(harvestDate!) : null,
      tags: tags,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

@JsonSerializable()
class ProductFarmerModel {
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  ProductFarmerModel({
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  factory ProductFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFarmerModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductFarmerModelToJson(this);

  ProductFarmer toEntity() => ProductFarmer(
        name: name,
        profileImage: profileImage,
        isVerified: isVerified,
      );
}
