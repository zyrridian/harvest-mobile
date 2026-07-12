import 'package:equatable/equatable.dart';

class FarmerOrder extends Equatable {
  final String id;
  final String orderNumber;
  final String status;
  final String buyerName;
  final String buyerPhone;
  final List<FarmerOrderItem> items;
  final double totalAmount;
  final String deliveryMethod;
  final String? deliveryDate;

  const FarmerOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.buyerName,
    required this.buyerPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryMethod,
    this.deliveryDate,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        buyerName,
        buyerPhone,
        items,
        totalAmount,
        deliveryMethod,
        deliveryDate,
      ];
}

class FarmerOrderItem extends Equatable {
  final String productName;
  final int quantity;
  final double subtotal;
  final String? productImage;

  const FarmerOrderItem({
    required this.productName,
    required this.quantity,
    required this.subtotal,
    this.productImage,
  });

  @override
  List<Object?> get props => [productName, quantity, subtotal, productImage];
}
