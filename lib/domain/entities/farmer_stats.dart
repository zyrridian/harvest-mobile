import 'package:equatable/equatable.dart';
import 'farmer_order.dart';

class FarmerStatsProfile extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;
  final num rating;
  final int totalReviews;

  const FarmerStatsProfile({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
    required this.rating,
    required this.totalReviews,
  });

  @override
  List<Object?> get props =>
      [id, name, profileImage, isVerified, rating, totalReviews];
}

class FarmerStatsEngagement extends Equatable {
  final int totalViews;
  final int followers;

  const FarmerStatsEngagement({
    required this.totalViews,
    required this.followers,
  });

  @override
  List<Object?> get props => [totalViews, followers];
}

class FarmerStats extends Equatable {
  final FarmerStatsProfile? profile;

  final int totalProducts;
  final int activeProducts;
  final int outOfStockProducts;

  final int totalOrders;
  final int pendingOrders;
  final int todayOrders;

  final double thisMonthRevenue;
  final double lastMonthRevenue;

  final FarmerStatsEngagement? engagement;

  final List<FarmerOrder> recentOrders;

  const FarmerStats({
    this.profile,
    required this.totalProducts,
    required this.activeProducts,
    required this.outOfStockProducts,
    required this.totalOrders,
    required this.pendingOrders,
    required this.todayOrders,
    required this.thisMonthRevenue,
    required this.lastMonthRevenue,
    this.engagement,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [
        profile,
        totalProducts,
        activeProducts,
        outOfStockProducts,
        totalOrders,
        pendingOrders,
        todayOrders,
        thisMonthRevenue,
        lastMonthRevenue,
        engagement,
        recentOrders,
      ];
}
