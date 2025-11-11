import 'dart:async';

import 'package:harvest_app/data/models/cart_model.dart';

/// Mock remote datasource for Cart. Replace with real ApiService integration.
class CartRemoteDataSource {
  CartRemoteDataSource();

  Future<CartModel> getCart() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final Map<String, dynamic> json = {
      "status": "success",
      "data": {
        "cart_id": "cart_1234567890",
        "items": [
          {
            "cart_item_id": "ci_001",
            "product": {
              "product_id": "prd_123",
              "name": "Organic Fresh Tomatoes",
              "price": 15000,
              "discount": {
                "discounted_price": 13500,
                "value": 10,
                "valid_until": "2025-10-15T23:59:59Z"
              },
              "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg",
              "unit": "kg",
              "stock_quantity": 100,
              "minimum_order": 1,
              "maximum_order": 50,
              "seller": {
                "user_id": "usr_987",
                "name": "Green Valley Farm",
                "location": {"city": "Bandung"}
              },
              "availability": {"status": "in_stock"}
            },
            "quantity": 3,
            "unit_price": 15000,
            "discount_price": 13500,
            "subtotal": 40500,
            "notes": "Please select ripe ones",
            "is_selected": true,
            "is_available": true,
            "added_at": "2025-10-08T10:00:00Z",
            "updated_at": "2025-10-09T09:00:00Z"
          },
          {
            "cart_item_id": "ci_002",
            "product": {
              "product_id": "prd_456",
              "name": "Fresh Cucumbers",
              "price": 12000,
              "discount": null,
              "image": "https://cdn.farmmarket.com/products/prd_456_001.jpg",
              "unit": "kg",
              "stock_quantity": 50,
              "seller": {
                "user_id": "usr_987",
                "name": "Green Valley Farm",
                "location": {"city": "Bandung"}
              },
              "availability": {"status": "in_stock"}
            },
            "quantity": 2,
            "unit_price": 12000,
            "discount_price": 12000,
            "subtotal": 24000,
            "notes": null,
            "is_selected": true,
            "is_available": true,
            "added_at": "2025-10-09T08:30:00Z",
            "updated_at": "2025-10-09T08:30:00Z"
          }
        ],
        "grouped_by_seller": [
          {
            "seller": {
              "user_id": "usr_987",
              "name": "Green Valley Farm",
              "profile_picture":
                  "https://cdn.farmmarket.com/profiles/usr_987.jpg",
              "location": {"city": "Bandung"}
            },
            "items": [],
            "subtotal": 64500,
            "delivery_fee": 15000,
            "free_delivery_threshold": 100000,
            "is_eligible_free_delivery": false,
            "amount_for_free_delivery": 35500,
            "total": 79500
          }
        ],
        "summary": {
          "total_items": 2,
          "total_quantity": 5,
          "subtotal": 64500,
          "total_discount": 4500,
          "total_delivery_fee": 15000,
          "service_fee": 2000,
          "grand_total": 81500
        },
        "unavailable_items": [],
        "recommendations": [
          {
            "product_id": "prd_789",
            "name": "Fresh Lettuce",
            "price": 8000,
            "image": "https://cdn.farmmarket.com/products/prd_789.jpg",
            "reason": "frequently_bought_together"
          }
        ],
        "updated_at": "2025-10-09T09:00:00Z"
      }
    };

    final data = json['data'] as Map<String, dynamic>;
    // Build CartModel from parsed data
    final items = (data['items'] as List<dynamic>)
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final summary =
        CartSummaryModel.fromJson(data['summary'] as Map<String, dynamic>);
    final grouped = (data['grouped_by_seller'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final recommendations =
        (data['recommendations'] as List<dynamic>).cast<Map<String, dynamic>>();

    return CartModel(
      cartId: data['cart_id'] ?? '',
      items: items,
      groupedBySeller: grouped,
      summary: summary,
      recommendations: recommendations,
    );
  }

  Future<Map<String, dynamic>> addItem(
      {required String productId, required int quantity, String? notes}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Commented example of real call:
    // final res = await apiService.post('/cart/items', data: {"product_id": productId, "quantity": quantity, "notes": notes});
    // return res.data;

    return {
      "status": "success",
      "message": "Product added to cart",
      "data": {
        "cart_item_id": "ci_new",
        "product_id": productId,
        "quantity": quantity,
        "subtotal": quantity * 15000,
        "cart_total_items": 3,
        "cart_grand_total": 120000
      }
    };
  }

  Future<Map<String, dynamic>> updateItem(
      {required String cartItemId,
      required int quantity,
      String? notes}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "status": "success",
      "message": "Cart item updated",
      "data": {
        "cart_item_id": cartItemId,
        "quantity": quantity,
        "subtotal": quantity * 15000,
        "cart_grand_total": 150000
      }
    };
  }

  Future<Map<String, dynamic>> removeItem({required String cartItemId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return {
      "status": "success",
      "message": "Item removed from cart",
      "data": {"cart_total_items": 1, "cart_grand_total": 24000}
    };
  }

  Future<Map<String, dynamic>> selectItem(
      {required String cartItemId, required bool isSelected}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return {
      "status": "success",
      "message": "Item selection updated",
      "data": {
        "cart_item_id": cartItemId,
        "is_selected": isSelected,
        "selected_items_total": 64500
      }
    };
  }

  Future<Map<String, dynamic>> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {"status": "success", "message": "Cart cleared successfully"};
  }

  Future<Map<String, dynamic>> validateCart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "status": "success",
      "data": {"is_valid": true, "changes": [], "warnings": []}
    };
  }
}
