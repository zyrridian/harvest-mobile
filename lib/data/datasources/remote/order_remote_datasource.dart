import 'dart:async';

import 'package:harvest_app/data/models/order_model.dart';

class OrderRemoteDataSource {
  OrderRemoteDataSource();

  Future<List<OrderModel>> getOrders(
      {required String role,
      String? status,
      int page = 1,
      int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final Map<String, dynamic> json = {
      "status": "success",
      "data": {
        "orders": [
          {
            "order_id": "ord_1234567890abcdef",
            "order_number": "FM20251009001",
            "status": "shipped",
            "seller": {
              "user_id": "usr_987",
              "name": "Green Valley Farm",
              "profile_picture":
                  "https://cdn.farmmarket.com/profiles/usr_987.jpg"
            },
            "items_preview": [
              {
                "product_id": "prd_123",
                "name": "Organic Fresh Tomatoes",
                "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg",
                "quantity": 3
              }
            ],
            "total_items": 2,
            "total_quantity": 5,
            "total_amount": 75050,
            "delivery": {
              "method": "home_delivery",
              "estimated_arrival": "2025-10-11",
              "tracking_number": "TRK123456789"
            },
            "created_at": "2025-10-09T11:30:00Z"
          }
        ]
      }
    };

    final orders = (json['data']!['orders'] as List<dynamic>).map((o) {
      final map = o as Map<String, dynamic>;
      final seller = OrderSellerModel(
          userId: map['seller']['user_id'] ?? '',
          name: map['seller']['name'] ?? '',
          profilePicture: map['seller']['profile_picture']);
      final items = <OrderItemModel>[];
      for (final it in (map['items_preview'] as List<dynamic>)) {
        final m = it as Map<String, dynamic>;
        items.add(OrderItemModel(
            orderItemId: m['product_id'] ?? '',
            product: {"product_id": m['product_id'], "name": m['name']},
            quantity: m['quantity'] ?? 1,
            unitPrice: 0,
            discount: 0,
            subtotal: 0));
      }
      final delivery = OrderDeliveryModel(
          method: map['delivery']?['method'] ?? 'home_delivery',
          address: {},
          date: map['delivery']?['estimated_arrival'],
          timeSlot: null,
          fee: 0);
      return OrderModel(
          orderId: map['order_id'] ?? '',
          orderNumber: map['order_number'] ?? '',
          status: map['status'] ?? '',
          seller: seller,
          items: items,
          delivery: delivery,
          totalAmount: map['total_amount'] ?? 0);
    }).toList();

    return orders;
  }

  Future<OrderModel> getOrderDetail({required String orderId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Map<String, dynamic> json = {
      "status": "success",
      "data": {
        "order_id": "ord_1234567890abcdef",
        "order_number": "FM20251009001",
        "status": "shipped",
        "seller": {
          "user_id": "usr_987",
          "name": "Green Valley Farm",
          "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
        },
        "items": [
          {
            "order_item_id": "oi_001",
            "product": {
              "product_id": "prd_123",
              "name": "Organic Fresh Tomatoes",
              "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg"
            },
            "quantity": 3,
            "unit_price": 15000,
            "discount": 1500,
            "subtotal": 40500
          }
        ],
        "delivery": {
          "method": "home_delivery",
          "address": {
            "address_id": "addr_123",
            "full_address": "Jl. Sudirman No. 123"
          },
          "date": "2025-10-11",
          "time_slot": "morning",
          "fee": 15000
        },
        "pricing": {"subtotal": 64500, "total": 75050},
        "payment": {"method": "bank_transfer", "status": "paid"},
        "created_at": "2025-10-09T11:30:00Z"
      }
    };

    final d = json['data'] as Map<String, dynamic>;
    final seller = OrderSellerModel(
        userId: d['seller']['user_id'] ?? '',
        name: d['seller']['name'] ?? '',
        profilePicture: d['seller']['profile_picture']);
    final items = (d['items'] as List<dynamic>)
        .map((it) => OrderItemModel.fromJson(it as Map<String, dynamic>))
        .toList();
    final delivery =
        OrderDeliveryModel.fromJson(d['delivery'] as Map<String, dynamic>);
    final model = OrderModel(
        orderId: d['order_id'] ?? '',
        orderNumber: d['order_number'] ?? '',
        status: d['status'] ?? '',
        seller: seller,
        items: items,
        delivery: delivery,
        totalAmount: d['pricing']?['total'] ?? d['total'] ?? 0);
    return model;
  }

  Future<Map<String, dynamic>> createOrder(
      {required Map<String, dynamic> payload}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return {
      "status": "success",
      "message": "Order created successfully",
      "data": {
        "orders": [
          {
            "order_id": "ord_new_1",
            "order_number": "FM20251009099",
            "status": "pending_payment",
            "total_amount": 75050
          }
        ],
        "payment_summary": {"total_orders": 1, "grand_total": 75050}
      }
    };
  }

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
