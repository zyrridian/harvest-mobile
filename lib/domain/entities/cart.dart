import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String cartItemId;
  final String productId;
  final String name;
  final int unitPrice;
  final int discountPrice;
  final int quantity;
  final int subtotal;
  final String? notes;
  final bool isSelected;
  final bool isAvailable;

  const CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.discountPrice,
    required this.quantity,
    required this.subtotal,
    this.notes,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  List<Object?> get props =>
      [cartItemId, productId, quantity, subtotal, isSelected];
}

class CartGroupedBySeller extends Equatable {
  final String sellerId;
  final String sellerName;
  final List<CartItem> items;
  final int subtotal;
  final int deliveryFee;
  final int total;

  const CartGroupedBySeller({
    required this.sellerId,
    required this.sellerName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [sellerId, items, subtotal, total];
}

class CartSummary extends Equatable {
  final int totalItems;
  final int totalQuantity;
  final int subtotal;
  final int totalDiscount;
  final int totalDeliveryFee;
  final int serviceFee;
  final int grandTotal;

  const CartSummary({
    required this.totalItems,
    required this.totalQuantity,
    required this.subtotal,
    required this.totalDiscount,
    required this.totalDeliveryFee,
    required this.serviceFee,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [totalItems, subtotal, grandTotal];
}

class Cart extends Equatable {
  final String cartId;
  final List<CartItem> items;
  final List<CartGroupedBySeller> groupedBySeller;
  final CartSummary summary;
  final List<Map<String, dynamic>> recommendations;

  const Cart({
    required this.cartId,
    required this.items,
    required this.groupedBySeller,
    required this.summary,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [cartId, items, summary];
}
