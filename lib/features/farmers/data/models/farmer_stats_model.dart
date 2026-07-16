import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_stats.dart';
import 'package:json_annotation/json_annotation.dart';

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
  final FarmerStatsProfileModel? profile;
  final ProductsStatModel products;
  final OrdersStatModel orders;
  final RevenueStatModel revenue;
  final FarmerStatsEngagementModel? engagement;
  @JsonKey(name: 'recent_orders')
  final List<FarmerStatsRecentOrderModel> recentOrders;

  FarmerStatsDataModel({
    this.profile,
    required this.products,
    required this.orders,
    required this.revenue,
    this.engagement,
    required this.recentOrders,
  });

  factory FarmerStatsDataModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsDataModelToJson(this);

  FarmerStats toEntity() {
    return FarmerStats(
      profile: profile?.toEntity(),
      totalProducts: products.total,
      activeProducts: products.active,
      outOfStockProducts: products.outOfStock,
      totalOrders: orders.total,
      pendingOrders: orders.pending,
      todayOrders: orders.today,
      thisMonthRevenue: revenue.thisMonth.toDouble(),
      lastMonthRevenue: revenue.lastMonth.toDouble(),
      engagement: engagement?.toEntity(),
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

@JsonSerializable(explicitToJson: true)
class FarmerStatsRecentOrderModel {
  final String id;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  @JsonKey(name: 'total_amount')
  final num totalAmount;
  @JsonKey(name: 'buyer_name')
  final String? buyerName;
  @JsonKey(name: 'buyer_avatar')
  final String? buyerAvatar;
  @JsonKey(name: 'first_item')
  final FarmerStatsFirstItemModel? firstItem;
  @JsonKey(name: 'items_count')
  final int? itemsCount;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  FarmerStatsRecentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.buyerName,
    this.buyerAvatar,
    this.firstItem,
    this.itemsCount,
    this.createdAt,
  });

  factory FarmerStatsRecentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsRecentOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsRecentOrderModelToJson(this);

  FarmerOrder toEntity() {
    return FarmerOrder(
      id: id,
      orderNumber: orderNumber,
      status: status,
      buyerName: buyerName ?? 'Unknown',
      buyerPhone: '',
      items: firstItem != null
          ? [
              FarmerOrderItem(
                  productName: firstItem!.name,
                  quantity: itemsCount ?? 1,
                  subtotal: totalAmount.toDouble(),
                  productImage: firstItem?.image)
            ]
          : [],
      totalAmount: totalAmount.toDouble(),
      deliveryMethod: 'direct',
      deliveryDate: createdAt,
    );
  }
}

@JsonSerializable()
class FarmerStatsFirstItemModel {
  final String name;
  final String? image;

  FarmerStatsFirstItemModel({
    required this.name,
    this.image,
  });

  factory FarmerStatsFirstItemModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsFirstItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsFirstItemModelToJson(this);
}

@JsonSerializable()
class FarmerStatsProfileModel {
  final String id;
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  final num rating;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;

  FarmerStatsProfileModel({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
    required this.rating,
    required this.totalReviews,
  });

  factory FarmerStatsProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsProfileModelToJson(this);

  FarmerStatsProfile toEntity() {
    return FarmerStatsProfile(
      id: id,
      name: name,
      profileImage: profileImage,
      isVerified: isVerified,
      rating: rating,
      totalReviews: totalReviews,
    );
  }
}

@JsonSerializable()
class FarmerStatsEngagementModel {
  @JsonKey(name: 'total_views')
  final int totalViews;
  final int followers;

  FarmerStatsEngagementModel({
    required this.totalViews,
    required this.followers,
  });

  factory FarmerStatsEngagementModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerStatsEngagementModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerStatsEngagementModelToJson(this);

  FarmerStatsEngagement toEntity() {
    return FarmerStatsEngagement(
      totalViews: totalViews,
      followers: followers,
    );
  }
}
