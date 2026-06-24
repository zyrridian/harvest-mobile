// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerStatsResponseModel _$FarmerStatsResponseModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsResponseModel(
      status: json['status'] as String,
      data: FarmerStatsDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FarmerStatsResponseModelToJson(
        FarmerStatsResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

FarmerStatsDataModel _$FarmerStatsDataModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsDataModel(
      profile: json['profile'] == null
          ? null
          : FarmerStatsProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>),
      products:
          ProductsStatModel.fromJson(json['products'] as Map<String, dynamic>),
      orders: OrdersStatModel.fromJson(json['orders'] as Map<String, dynamic>),
      revenue:
          RevenueStatModel.fromJson(json['revenue'] as Map<String, dynamic>),
      engagement: json['engagement'] == null
          ? null
          : FarmerStatsEngagementModel.fromJson(
              json['engagement'] as Map<String, dynamic>),
      recentOrders: (json['recent_orders'] as List<dynamic>)
          .map((e) =>
              FarmerStatsRecentOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FarmerStatsDataModelToJson(
        FarmerStatsDataModel instance) =>
    <String, dynamic>{
      'profile': instance.profile?.toJson(),
      'products': instance.products.toJson(),
      'orders': instance.orders.toJson(),
      'revenue': instance.revenue.toJson(),
      'engagement': instance.engagement?.toJson(),
      'recent_orders': instance.recentOrders.map((e) => e.toJson()).toList(),
    };

ProductsStatModel _$ProductsStatModelFromJson(Map<String, dynamic> json) =>
    ProductsStatModel(
      total: (json['total'] as num).toInt(),
      active: (json['active'] as num).toInt(),
      outOfStock: (json['out_of_stock'] as num).toInt(),
    );

Map<String, dynamic> _$ProductsStatModelToJson(ProductsStatModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'active': instance.active,
      'out_of_stock': instance.outOfStock,
    };

OrdersStatModel _$OrdersStatModelFromJson(Map<String, dynamic> json) =>
    OrdersStatModel(
      total: (json['total'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      today: (json['today'] as num).toInt(),
    );

Map<String, dynamic> _$OrdersStatModelToJson(OrdersStatModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'pending': instance.pending,
      'today': instance.today,
    };

RevenueStatModel _$RevenueStatModelFromJson(Map<String, dynamic> json) =>
    RevenueStatModel(
      thisMonth: json['this_month'] as num,
      lastMonth: json['last_month'] as num,
    );

Map<String, dynamic> _$RevenueStatModelToJson(RevenueStatModel instance) =>
    <String, dynamic>{
      'this_month': instance.thisMonth,
      'last_month': instance.lastMonth,
    };

FarmerStatsRecentOrderModel _$FarmerStatsRecentOrderModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsRecentOrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      totalAmount: json['total_amount'] as num,
      buyerName: json['buyer_name'] as String?,
      buyerAvatar: json['buyer_avatar'] as String?,
      firstItem: json['first_item'] == null
          ? null
          : FarmerStatsFirstItemModel.fromJson(
              json['first_item'] as Map<String, dynamic>),
      itemsCount: (json['items_count'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$FarmerStatsRecentOrderModelToJson(
        FarmerStatsRecentOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'buyer_name': instance.buyerName,
      'buyer_avatar': instance.buyerAvatar,
      'first_item': instance.firstItem?.toJson(),
      'items_count': instance.itemsCount,
      'created_at': instance.createdAt,
    };

FarmerStatsFirstItemModel _$FarmerStatsFirstItemModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsFirstItemModel(
      name: json['name'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$FarmerStatsFirstItemModelToJson(
        FarmerStatsFirstItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };

FarmerStatsProfileModel _$FarmerStatsProfileModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profile_image'] as String,
      isVerified: json['is_verified'] as bool,
      rating: json['rating'] as num,
      totalReviews: (json['total_reviews'] as num).toInt(),
    );

Map<String, dynamic> _$FarmerStatsProfileModelToJson(
        FarmerStatsProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_image': instance.profileImage,
      'is_verified': instance.isVerified,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
    };

FarmerStatsEngagementModel _$FarmerStatsEngagementModelFromJson(
        Map<String, dynamic> json) =>
    FarmerStatsEngagementModel(
      totalViews: (json['total_views'] as num).toInt(),
      followers: (json['followers'] as num).toInt(),
    );

Map<String, dynamic> _$FarmerStatsEngagementModelToJson(
        FarmerStatsEngagementModel instance) =>
    <String, dynamic>{
      'total_views': instance.totalViews,
      'followers': instance.followers,
    };
