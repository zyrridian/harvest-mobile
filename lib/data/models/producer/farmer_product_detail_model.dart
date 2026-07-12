import 'package:harvest_app/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_request.dart';

class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    required super.url,
    required super.isPrimary,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      url: json['url'] ?? '',
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'is_primary': isPrimary,
    };
  }
}

class ProductSpecificationModel extends ProductSpecificationEntity {
  const ProductSpecificationModel({
    required super.key,
    required super.value,
  });

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}

class FarmerProductDetailModel extends FarmerProductDetail {
  const FarmerProductDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.longDescription,
    required super.price,
    required super.unit,
    required super.stock,
    required super.minimumOrder,
    required super.maximumOrder,
    required super.isOrganic,
    required super.isAvailable,
    required super.isHarvest,
    super.targetAmount,
    super.harvestDate,
    super.categoryId,
    required List<ProductImageModel> super.images,
    required super.tags,
    required List<ProductSpecificationModel> super.specifications,
  });

  factory FarmerProductDetailModel.fromJson(Map<String, dynamic> json) {
    return FarmerProductDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      longDescription: json['long_description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      stock: json['stock'] ?? 0,
      minimumOrder: json['minimum_order'] ?? 1,
      maximumOrder: json['maximum_order'] ?? 10,
      isOrganic: json['is_organic'] ?? false,
      isAvailable: json['is_available'] ?? false,
      isHarvest: json['is_harvest'] ?? false,
      targetAmount: json['target_amount']?.toDouble(),
      harvestDate: json['harvest_date'] != null
          ? DateTime.tryParse(json['harvest_date'])
          : null,
      categoryId: json['category_id'],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) =>
                  ProductSpecificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  FarmerProductDetail toEntity() {
    return FarmerProductDetail(
      id: id,
      name: name,
      description: description,
      longDescription: longDescription,
      price: price,
      unit: unit,
      stock: stock,
      minimumOrder: minimumOrder,
      maximumOrder: maximumOrder,
      isOrganic: isOrganic,
      isAvailable: isAvailable,
      isHarvest: isHarvest,
      targetAmount: targetAmount,
      harvestDate: harvestDate,
      categoryId: categoryId,
      images: images,
      tags: tags,
      specifications: specifications,
    );
  }
}

class ProductRequestModel extends ProductRequest {
  const ProductRequestModel({
    required super.name,
    required super.description,
    required super.longDescription,
    required super.price,
    required super.unit,
    required super.stock,
    required super.minimumOrder,
    required super.maximumOrder,
    required super.isOrganic,
    required super.isAvailable,
    required super.isHarvest,
    super.targetAmount,
    super.harvestDate,
    super.categoryId,
    required List<ProductImageModel> super.images,
    required super.tags,
    required List<ProductSpecificationModel> super.specifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'long_description': longDescription,
      'price': price,
      'unit': unit,
      'stock': stock,
      'minimum_order': minimumOrder,
      'maximum_order': maximumOrder,
      'is_organic': isOrganic,
      'is_available': isAvailable,
      'is_harvest': isHarvest,
      'target_amount': targetAmount,
      'harvest_date': harvestDate?.toIso8601String().split('T').first,
      'category_id': categoryId,
      'images': images.map((e) => (e as ProductImageModel).toJson()).toList(),
      'tags': tags,
      'specifications':
          specifications.map((e) => (e as ProductSpecificationModel).toJson()).toList(),
    };
  }

  factory ProductRequestModel.fromEntity(ProductRequest entity) {
    return ProductRequestModel(
      name: entity.name,
      description: entity.description,
      longDescription: entity.longDescription,
      price: entity.price,
      unit: entity.unit,
      stock: entity.stock,
      minimumOrder: entity.minimumOrder,
      maximumOrder: entity.maximumOrder,
      isOrganic: entity.isOrganic,
      isAvailable: entity.isAvailable,
      isHarvest: entity.isHarvest,
      targetAmount: entity.targetAmount,
      harvestDate: entity.harvestDate,
      categoryId: entity.categoryId,
      images: entity.images
          .map((e) => ProductImageModel(url: e.url, isPrimary: e.isPrimary))
          .toList(),
      tags: entity.tags,
      specifications: entity.specifications
          .map((e) => ProductSpecificationModel(key: e.key, value: e.value))
          .toList(),
    );
  }
}
