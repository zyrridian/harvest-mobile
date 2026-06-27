import 'package:equatable/equatable.dart';

class ProductDetail extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String category;
  final String categoryId;
  final String categoryName;
  final String sellerId;
  final String sellerName;
  final double price;
  final String currency;
  final String unit;
  final String? image;
  final String imageUrl;
  final List<String> images;
  final bool isOrganic;
  final bool isAvailable;
  final int stockQuantity;
  final double? discount;
  final double rating;
  final int reviewCount;
  final ProductFarmer farmer;
  final bool isHarvest;
  final double? targetAmount;
  final double currentBooked;
  final DateTime? harvestDate;
  final List<String> tags;
  final DateTime createdAt;

  const ProductDetail({
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

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        category,
        categoryId,
        categoryName,
        sellerId,
        sellerName,
        price,
        currency,
        unit,
        image,
        imageUrl,
        images,
        isOrganic,
        isAvailable,
        stockQuantity,
        discount,
        rating,
        reviewCount,
        farmer,
        isHarvest,
        targetAmount,
        currentBooked,
        harvestDate,
        tags,
        createdAt,
      ];
}

class ProductFarmer extends Equatable {
  final String name;
  final String? profileImage;
  final bool isVerified;

  const ProductFarmer({
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [name, profileImage, isVerified];
}


