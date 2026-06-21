import 'package:equatable/equatable.dart';
import 'farmer_order.dart';

class FarmerStats extends Equatable {
  final int totalProducts;
  final int activeProducts;
  final int outOfStockProducts;
  
  final int totalOrders;
  final int pendingOrders;
  final int todayOrders;
  
  final double thisMonthRevenue;
  final double lastMonthRevenue;
  
  final List<FarmerOrder> recentOrders;

  const FarmerStats({
    required this.totalProducts,
    required this.activeProducts,
    required this.outOfStockProducts,
    required this.totalOrders,
    required this.pendingOrders,
    required this.todayOrders,
    required this.thisMonthRevenue,
    required this.lastMonthRevenue,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [
        totalProducts,
        activeProducts,
        outOfStockProducts,
        totalOrders,
        pendingOrders,
        todayOrders,
        thisMonthRevenue,
        lastMonthRevenue,
        recentOrders,
      ];
}
