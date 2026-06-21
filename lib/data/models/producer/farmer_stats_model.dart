import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/farmer_stats.dart';
import 'farmer_order_model.dart';

part 'farmer_stats_model.g.dart';

@JsonSerializable()
class FarmerStatsResponseModel {
  final String status;
  final FarmerStatsDataModel data;

  FarmerStatsResponseModel({
    required this.status,
    required this.data,
  });

  factory FarmerStatsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FarmerStatsDataModel {
  final ProductsStatModel products;
  final OrdersStatModel orders;
  final RevenueStatModel revenue;
  @JsonKey(name: 'recent_orders')
  final List<FarmerOrderModel> recentOrders;

  FarmerStatsDataModel({
    required this.products,
    required this.orders,
    required this.revenue,
    required this.recentOrders,
  });

  factory FarmerStatsDataModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsDataModelToJson(this);

  FarmerStats toEntity() {
    return FarmerStats(
      totalProducts: products.total,
      activeProducts: products.active,
      outOfStockProducts: products.outOfStock,
      totalOrders: orders.total,
      pendingOrders: orders.pending,
      todayOrders: orders.today,
      thisMonthRevenue: revenue.thisMonth.toDouble(),
      lastMonthRevenue: revenue.lastMonth.toDouble(),
      recentOrders: recentOrders.map((e) => e.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class ProductsStatModel {
  final int total;
  final int active;
  @JsonKey(name: 'out_of_stock')
  final int outOfStock;

  ProductsStatModel({
    required this.total,
    required this.active,
    required this.outOfStock,
  });

  factory ProductsStatModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsStatModelToJson(this);
}

@JsonSerializable()
class OrdersStatModel {
  final int total;
  final int pending;
  final int today;

  OrdersStatModel({
    required this.total,
    required this.pending,
    required this.today,
  });

  factory OrdersStatModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersStatModelToJson(this);
}

@JsonSerializable()
class RevenueStatModel {
  @JsonKey(name: 'this_month')
  final num thisMonth;
  @JsonKey(name: 'last_month')
  final num lastMonth;

  RevenueStatModel({
    required this.thisMonth,
    required this.lastMonth,
  });

  factory RevenueStatModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueStatModelToJson(this);
}
