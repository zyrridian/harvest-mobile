import 'dart:async';

import 'package:dio/dio.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/sales/data/models/cart_model.dart';

class CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSource(this.dio);

  Future<CartModel> getCart() async {
    try {
      final response = await dio.get('/sales/cart');
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
    try {
      final response = await dio.post(
        '/sales/cart/items',
        data: {
          "product_id": productId,
          "quantity": quantity,
          if (notes != null) "notes": notes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data['data'] as Map<String, dynamic>;
        } else {
          throw ServerException(data['message'] ?? 'Failed to add item to cart');
        }
      } else {
        throw ServerException('Failed to add item to cart');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> updateItem(
      {required String cartItemId,
      required int quantity,
      String? notes}) async {
    try {
      final response = await dio.patch(
        '/sales/cart/items/$cartItemId',
        data: {
          "quantity": quantity,
          if (notes != null) "notes": notes,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data['data'] as Map<String, dynamic>;
        } else {
          throw ServerException(data['message'] ?? 'Failed to update item');
        }
      } else {
        throw ServerException('Failed to update item');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> removeItem({required String cartItemId}) async {
    try {
      final response = await dio.delete('/sales/cart/items/$cartItemId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data['data'] as Map<String, dynamic>;
        } else {
          throw ServerException(data['message'] ?? 'Failed to remove item');
        }
      } else {
        throw ServerException('Failed to remove item');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> selectItem(
      {required String cartItemId, required bool isSelected}) async {
    try {
      final response = await dio.patch(
        '/sales/cart/items/$cartItemId/select',
        data: {"is_selected": isSelected},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return data['data'] as Map<String, dynamic>;
        } else {
          throw ServerException(data['message'] ?? 'Failed to update selection');
        }
      } else {
        throw ServerException('Failed to update selection');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> clearCart() async {
    try {
      final response = await dio.delete('/sales/cart');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return {"status": "success", "message": data['message'] ?? "Cart cleared"};
        } else {
          throw ServerException(data['message'] ?? 'Failed to clear cart');
        }
      } else {
        throw ServerException('Failed to clear cart');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> validateCart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "status": "success",
      "data": {"is_valid": true, "changes": [], "warnings": []}
    };
  }
}
