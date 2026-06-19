import 'package:harvest_app/domain/entities/category_product.dart';

class CategoryProductModel extends CategoryProduct {
  CategoryProductModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.categoryName,
    required super.sellerId,
    required super.sellerName,
    required super.price,
    required super.unit,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    super.isPremium,
    super.isOrganic,
    required super.stockQuantity,
    super.discount,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isPremium: json['isPremium'] as bool? ?? false,
      isOrganic: json['isOrganic'] as bool? ?? false,
      stockQuantity: json['stockQuantity'] as int,
      discount: json['discount'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPremium': isPremium,
      'isOrganic': isOrganic,
      'stockQuantity': stockQuantity,
      'discount': discount,
    };
  }

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
      isPremium: isPremium,
      isOrganic: isOrganic,
      stockQuantity: stockQuantity,
      discount: discount,
    );
  }
}
