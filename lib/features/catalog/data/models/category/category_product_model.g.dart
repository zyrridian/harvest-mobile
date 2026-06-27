// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductModel _$CategoryProductModelFromJson(
        Map<String, dynamic> json) =>
    CategoryProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      isOrganic: json['is_organic'] as bool,
      isAvailable: json['is_available'] as bool,
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      discount: (json['discount'] as num?)?.toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      farmer: FarmerModel.fromJson(json['farmer'] as Map<String, dynamic>),
      isHarvest: json['is_harvest'] as bool,
      targetAmount: (json['target_amount'] as num?)?.toDouble(),
      currentBooked: (json['current_booked'] as num).toDouble(),
      harvestDate: json['harvest_date'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$CategoryProductModelToJson(
        CategoryProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'category': instance.category,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'seller_id': instance.sellerId,
      'seller_name': instance.sellerName,
      'price': instance.price,
      'currency': instance.currency,
      'unit': instance.unit,
      'image': instance.image,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'is_organic': instance.isOrganic,
      'is_available': instance.isAvailable,
      'stock_quantity': instance.stockQuantity,
      'discount': instance.discount,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'farmer': instance.farmer,
      'is_harvest': instance.isHarvest,
      'target_amount': instance.targetAmount,
      'current_booked': instance.currentBooked,
      'harvest_date': instance.harvestDate,
      'tags': instance.tags,
      'created_at': instance.createdAt,
    };

FarmerModel _$FarmerModelFromJson(Map<String, dynamic> json) => FarmerModel(
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      isVerified: json['is_verified'] as bool,
    );

Map<String, dynamic> _$FarmerModelToJson(FarmerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profile_image': instance.profileImage,
      'is_verified': instance.isVerified,
    };
