import 'package:equatable/equatable.dart';
import 'farmer_product_detail.dart';

class ProductRequest extends Equatable {
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

  const ProductRequest({
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
