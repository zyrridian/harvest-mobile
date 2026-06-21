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
      products:
          ProductsStatModel.fromJson(json['products'] as Map<String, dynamic>),
      orders: OrdersStatModel.fromJson(json['orders'] as Map<String, dynamic>),
      revenue:
          RevenueStatModel.fromJson(json['revenue'] as Map<String, dynamic>),
      recentOrders: (json['recent_orders'] as List<dynamic>)
          .map((e) => FarmerOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FarmerStatsDataModelToJson(
        FarmerStatsDataModel instance) =>
    <String, dynamic>{
      'products': instance.products.toJson(),
      'orders': instance.orders.toJson(),
      'revenue': instance.revenue.toJson(),
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
