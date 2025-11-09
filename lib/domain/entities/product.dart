import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String unit; // kg, pcs, bunch, etc.
  final String imageUrl;
  final List<String> images;
  final bool isOrganic;
  final bool isAvailable;
  final int stock;
  final double? discount;
  final double rating;
  final int reviewCount;
  final String farmerId;
  final String farmerName;
  final DateTime? harvestDate;
  final List<String> tags;
  final DateTime createdAt;

  const Product({
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

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        price,
        unit,
        imageUrl,
        images,
        isOrganic,
        isAvailable,
        stock,
        discount,
        rating,
        reviewCount,
        farmerId,
        farmerName,
        harvestDate,
        tags,
        createdAt,
      ];
}
