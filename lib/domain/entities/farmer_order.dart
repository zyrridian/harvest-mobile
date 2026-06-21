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

  const FarmerOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.buyerName,
    required this.buyerPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryMethod,
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
      ];
}

class FarmerOrderItem extends Equatable {
  final String productName;
  final int quantity;
  final double subtotal;

  const FarmerOrderItem({
    required this.productName,
    required this.quantity,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [productName, quantity, subtotal];
}
