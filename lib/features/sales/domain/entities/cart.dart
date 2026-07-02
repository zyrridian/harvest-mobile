import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String cartItemId;
  final String productId;
  final String name;
  final String? imageUrl;
  final num unitPrice;
  final num discountPrice;
  final int quantity;
  final num subtotal;
  final String? notes;
  final bool isSelected;
  final bool isAvailable;

  const CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    this.imageUrl,
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

  CartItem copyWith({
    String? cartItemId,
    String? productId,
    String? name,
    String? imageUrl,
    num? unitPrice,
    num? discountPrice,
    int? quantity,
    num? subtotal,
    String? notes,
    bool? isSelected,
    bool? isAvailable,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      notes: notes ?? this.notes,
      isSelected: isSelected ?? this.isSelected,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class CartGroupedBySeller extends Equatable {
  final String sellerId;
  final String sellerName;
  final List<CartItem> items;
  final num subtotal;
  final num deliveryFee;
  final num total;

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
  final num subtotal;
  final num totalDiscount;
  final num totalDeliveryFee;
  final num serviceFee;
  final num grandTotal;

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

  Cart copyWith({
    String? cartId,
    List<CartItem>? items,
    List<CartGroupedBySeller>? groupedBySeller,
    CartSummary? summary,
    List<Map<String, dynamic>>? recommendations,
  }) {
    return Cart(
      cartId: cartId ?? this.cartId,
      items: items ?? this.items,
      groupedBySeller: groupedBySeller ?? this.groupedBySeller,
      summary: summary ?? this.summary,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}
