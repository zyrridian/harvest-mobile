import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/sales/data/models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<void> cacheOrders(List<OrderModel> orders);
  Future<List<OrderModel>> getOrders();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedOrdersKey = 'CACHED_ORDERS';

  OrderLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    final List<Map<String, dynamic>> orderList =
        orders.map((order) => order.toJson()).toList();
    await sharedPreferences.setString(
      cachedOrdersKey,
      json.encode(orderList),
    );
  }

  @override
  Future<List<OrderModel>> getOrders() {
    final jsonString = sharedPreferences.getString(cachedOrdersKey);
    if (jsonString != null) {
      final List<dynamic> jsonMap = json.decode(jsonString);
      return Future.value(
          jsonMap.map((e) => OrderModel.fromJson(e)).toList());
    } else {
      throw CacheException('No cached orders found');
    }
  }
}
