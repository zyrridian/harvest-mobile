import 'dart:async';

import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/data/models/cart_model.dart';

class CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSource(this.dio);

  Future<CartModel> getCart() async {
    try {
      final response = await dio.get('/cart');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final data = response.data['data'] as Map<String, dynamic>;
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
      } else {
        throw ServerException('Failed to get cart');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
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
