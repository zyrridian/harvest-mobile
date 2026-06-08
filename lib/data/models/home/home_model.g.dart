// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => HomeCategoriesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      preOrders: (json['pre_orders'] as List<dynamic>)
          .map((e) => HomePreOrdersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyFarmers: HomeNearbyFarmersModel.fromJson(
          json['nearby_farmers'] as Map<String, dynamic>),
      freshToday: (json['fresh_today'] as List<dynamic>)
          .map((e) => HomeFreshTodayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'pre_orders': instance.preOrders.map((e) => e.toJson()).toList(),
      'nearby_farmers': instance.nearbyFarmers.toJson(),
      'fresh_today': instance.freshToday.map((e) => e.toJson()).toList(),
    };

HomeCategoriesModel _$HomeCategoriesModelFromJson(Map<String, dynamic> json) =>
    HomeCategoriesModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      emoji: json['emoji'] as String,
      gradientColors: (json['gradient_colors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productCount: (json['product_count'] as num).toInt(),
    );

Map<String, dynamic> _$HomeCategoriesModelToJson(
        HomeCategoriesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'emoji': instance.emoji,
      'gradient_colors': instance.gradientColors,
      'product_count': instance.productCount,
    };

HomePreOrdersModel _$HomePreOrdersModelFromJson(Map<String, dynamic> json) =>
    HomePreOrdersModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num).toDouble(),
      farmerName: json['farmer_name'] as String,
      availableDate: DateTime.parse(json['available_date'] as String),
    );

Map<String, dynamic> _$HomePreOrdersModelToJson(HomePreOrdersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'farmer_name': instance.farmerName,
      'available_date': instance.availableDate.toIso8601String(),
    };

HomeNearbyFarmersModel _$HomeNearbyFarmersModelFromJson(
        Map<String, dynamic> json) =>
    HomeNearbyFarmersModel(
      count: (json['count'] as num).toInt(),
      radiusKm: (json['radius_km'] as num).toInt(),
      farmers: (json['farmers'] as List<dynamic>)
          .map((e) => HomeFarmerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeNearbyFarmersModelToJson(
        HomeNearbyFarmersModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'radius_km': instance.radiusKm,
      'farmers': instance.farmers.map((e) => e.toJson()).toList(),
    };

HomeFarmerModel _$HomeFarmerModelFromJson(Map<String, dynamic> json) =>
    HomeFarmerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalProducts: (json['total_products'] as num?)?.toInt(),
      isVerified: json['is_verified'] as bool?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeFarmerModelToJson(HomeFarmerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image': instance.profileImage,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'rating': instance.rating,
      'total_products': instance.totalProducts,
      'is_verified': instance.isVerified,
      'distance_km': instance.distanceKm,
    };

HomeFreshTodayModel _$HomeFreshTodayModelFromJson(Map<String, dynamic> json) =>
    HomeFreshTodayModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String,
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      isOrganic: json['is_organic'] as bool,
      image: json['image'] as String?,
      farmer: HomeFreshTodayFarmerModel.fromJson(
          json['farmer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeFreshTodayModelToJson(
        HomeFreshTodayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'price': instance.price,
      'currency': instance.currency,
      'unit': instance.unit,
      'stock_quantity': instance.stockQuantity,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_organic': instance.isOrganic,
      'image': instance.image,
      'farmer': instance.farmer.toJson(),
    };

HomeFreshTodayFarmerModel _$HomeFreshTodayFarmerModelFromJson(
        Map<String, dynamic> json) =>
    HomeFreshTodayFarmerModel(
      name: json['name'] as String,
      profileImage: json['profile_image'] as String?,
      isVerified: json['is_verified'] as bool,
    );

Map<String, dynamic> _$HomeFreshTodayFarmerModelToJson(
        HomeFreshTodayFarmerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profile_image': instance.profileImage,
      'is_verified': instance.isVerified,
    };
