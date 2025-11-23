import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/domain/entities/cart.dart';

part 'cart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel {
  @JsonKey(name: 'cart_item_id')
  final String cartItemId;
  @JsonKey(name: 'product')
  final Map<String, dynamic> product;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final int unitPrice;
  @JsonKey(name: 'discount_price')
  final int discountPrice;
  final int subtotal;
  final String? notes;
  @JsonKey(name: 'is_selected')
  final bool isSelected;
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  CartItemModel({
    required this.cartItemId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.discountPrice,
    required this.subtotal,
    this.notes,
    required this.isSelected,
    required this.isAvailable,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItem toEntity() {
    final prod = product;
    return CartItem(
      cartItemId: cartItemId,
      productId: prod['product_id'] ?? prod['productId'] ?? '',
      name: prod['name'] ?? '',
      unitPrice: unitPrice,
      discountPrice: discountPrice,
      quantity: quantity,
      subtotal: subtotal,
      notes: notes,
      isSelected: isSelected,
      isAvailable: isAvailable,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CartSummaryModel {
  @JsonKey(name: 'total_items')
  final int totalItems;
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  final int subtotal;
  @JsonKey(name: 'total_discount')
  final int totalDiscount;
  @JsonKey(name: 'total_delivery_fee')
  final int totalDeliveryFee;
  @JsonKey(name: 'service_fee')
  final int serviceFee;
  @JsonKey(name: 'grand_total')
  final int grandTotal;

  CartSummaryModel({
    required this.totalItems,
    required this.totalQuantity,
    required this.subtotal,
    required this.totalDiscount,
    required this.totalDeliveryFee,
    required this.serviceFee,
    required this.grandTotal,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartSummaryModelToJson(this);

  CartSummary toEntity() => CartSummary(
        totalItems: totalItems,
        totalQuantity: totalQuantity,
        subtotal: subtotal,
        totalDiscount: totalDiscount,
        totalDeliveryFee: totalDeliveryFee,
        serviceFee: serviceFee,
        grandTotal: grandTotal,
      );
}

@JsonSerializable(explicitToJson: true)
class CartModel {
  @JsonKey(name: 'cart_id')
  final String cartId;
  final List<CartItemModel> items;
  @JsonKey(name: 'grouped_by_seller')
  final List<Map<String, dynamic>> groupedBySeller;
  final CartSummaryModel summary;
  final List<Map<String, dynamic>> recommendations;

  CartModel({
    required this.cartId,
    required this.items,
    required this.groupedBySeller,
    required this.summary,
    required this.recommendations,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  Cart toEntity() => Cart(
        cartId: cartId,
        items: items.map((e) => e.toEntity()).toList(),
        groupedBySeller: groupedBySeller.map((g) {
          final seller = g['seller'] ?? {};
          final itemsList = (g['items'] as List<dynamic>?)
                  ?.map((it) =>
                      CartItemModel.fromJson(it as Map<String, dynamic>)
                          .toEntity())
                  .toList() ??
              [];
          return CartGroupedBySeller(
            sellerId: seller['user_id'] ?? '',
            sellerName: seller['name'] ?? '',
            items: itemsList,
            subtotal: g['subtotal'] ?? 0,
            deliveryFee: g['delivery_fee'] ?? 0,
            total: g['total'] ?? 0,
          );
        }).toList(),
        summary: summary.toEntity(),
        recommendations: recommendations,
      );
}
