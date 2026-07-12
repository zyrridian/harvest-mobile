import 'package:equatable/equatable.dart';

class ProductImageEntity extends Equatable {
  final String url;
  final bool isPrimary;

  const ProductImageEntity({
    required this.url,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [url, isPrimary];
}

class ProductSpecificationEntity extends Equatable {
  final String key;
  final String value;

  const ProductSpecificationEntity({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

class FarmerProductDetail extends Equatable {
  final String id;
  final String name;
  final String description;
  final String longDescription;
  final double price;
  final String unit;
  final int stock;
  final int minimumOrder;
  final int maximumOrder;
  final bool isOrganic;
  final bool isAvailable;
  final bool isHarvest;
  final double? targetAmount;
  final DateTime? harvestDate;
  final String? categoryId;
  final List<ProductImageEntity> images;
  final List<String> tags;
  final List<ProductSpecificationEntity> specifications;

  const FarmerProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.price,
    required this.unit,
    required this.stock,
    required this.minimumOrder,
    required this.maximumOrder,
    required this.isOrganic,
    required this.isAvailable,
    required this.isHarvest,
    this.targetAmount,
    this.harvestDate,
    this.categoryId,
    required this.images,
    required this.tags,
    required this.specifications,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        longDescription,
        price,
        unit,
        stock,
        minimumOrder,
        maximumOrder,
        isOrganic,
        isAvailable,
        isHarvest,
        targetAmount,
        harvestDate,
        categoryId,
        images,
        tags,
        specifications,
      ];
}
