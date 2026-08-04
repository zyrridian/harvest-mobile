import 'dart:async';

import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/sales/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(
      {required String role, String? status, int page = 1, int limit = 20});
  Future<OrderModel> getOrderDetail({required String orderId});
  Future<Map<String, dynamic>> createOrder(
      {required Map<String, dynamic> payload});
  Future<Map<String, dynamic>> cancelOrder(
      {required String orderId, required Map<String, dynamic> payload});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<List<OrderModel>> getOrders(
      {required String role,
      String? status,
      int page = 1,
      int limit = 20}) async {
    try {
      final queryParams = {
        'role': role,
        'page': page,
        'limit': limit,
      };
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await dio.get(
        AppConstants.ordersEndpoint,
        queryParameters: queryParams,
      );

      final data = response.data['data'];
      if (data == null || data['orders'] == null) return [];

      final orders = (data['orders'] as List<dynamic>).map((o) {
        final map = o as Map<String, dynamic>;
        final sellerMap = map['seller'] ?? {};
        final seller = OrderSellerModel(
            userId: sellerMap['user_id'] ?? '',
            name: sellerMap['name'] ?? '',
            profilePicture: sellerMap['profile_picture']);

        final items = <OrderItemModel>[];
        final itemsList = map['items'] as List<dynamic>? ?? [];
        for (final it in itemsList) {
          final m = it as Map<String, dynamic>;
          items.add(OrderItemModel(
              orderItemId: m['order_item_id'] ?? m['product_id'] ?? '',
              productId: m['product_id'],
              productName: m['product_name'] ?? m['name'],
              image: m['image'],
              product: m['product'] as Map<String, dynamic>?,
              quantity: m['quantity'] ?? 1,
              unitPrice: m['unit_price'] ?? 0,
              discount: m['discount'] ?? 0,
              subtotal: m['subtotal'] ?? 0));
        }

        final deliveryMap = map['delivery'] ?? {};
        final delivery = OrderDeliveryModel(
            method: deliveryMap['method'] ?? 'home_delivery',
            address: {}, // not provided in listing
            date: deliveryMap['date'],
            timeSlot: null,
            fee: 0);

        return OrderModel(
            orderId: map['order_id'] ?? '',
            orderNumber: map['order_number'] ?? '',
            status: map['status'] ?? '',
            seller: seller,
            items: items,
            delivery: delivery,
            totalAmount: map['total_amount'] ?? 0,
            paymentUrl: map['payment']?['payment_url']);
      }).toList();

      return orders;
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<OrderModel> getOrderDetail({required String orderId}) async {
    try {
      final response = await dio.get('${AppConstants.ordersEndpoint}/$orderId');

      final d = response.data['data'] as Map<String, dynamic>;
      final seller = OrderSellerModel(
          userId: d['seller']['user_id'] ?? '',
          name: d['seller']['name'] ?? '',
          profilePicture: d['seller']['profile_picture']);
      final items = (d['items'] as List<dynamic>)
          .map((it) => OrderItemModel.fromJson(it as Map<String, dynamic>))
          .toList();
      final deliveryMap = d['delivery'] as Map<String, dynamic>? ?? {};
      final delivery = OrderDeliveryModel(
          method: deliveryMap['method'] ?? 'unknown',
          address: deliveryMap['address'] as Map<String, dynamic>?,
          date: deliveryMap['date'],
          timeSlot: deliveryMap['time_slot'],
          fee: deliveryMap['fee'] ?? 0);
      final model = OrderModel(
          orderId: d['order_id'] ?? '',
          orderNumber: d['order_number'] ?? '',
          status: d['status'] ?? '',
          seller: seller,
          items: items,
          delivery: delivery,
          totalAmount: d['pricing']?['total'] ?? d['total'] ?? 0,
          paymentUrl: d['payment']?['payment_url']);
      return model;
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(
      {required Map<String, dynamic> payload}) async {
    try {
      final response = await dio.post(
        AppConstants.ordersEndpoint,
        data: payload,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to create order');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> cancelOrder(
      {required String orderId, required Map<String, dynamic> payload}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "status": "success",
      "message": "Order cancelled successfully",
      "data": {"order_id": orderId, "status": "cancelled"}
    };
  }
}
