import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String orderItemId;
  final String productId;
  final String name;
  final int quantity;
  final int unitPrice;
  final int discount;
  final int subtotal;

  const OrderItem({
    required this.orderItemId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [orderItemId, productId, quantity, subtotal];
}

class OrderSeller extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;

  const OrderSeller(
      {required this.userId, required this.name, this.profilePicture});

  @override
  List<Object?> get props => [userId, name];
}

class OrderDelivery extends Equatable {
  final String method;
  final String? address;
  final String? date;
  final String? timeSlot;
  final int fee;

  const OrderDelivery(
      {required this.method,
      this.address,
      this.date,
      this.timeSlot,
      this.fee = 0});

  @override
  List<Object?> get props => [method, address, date];
}

class Order extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final OrderSeller seller;
  final List<OrderItem> items;
  final OrderDelivery delivery;
  final int totalAmount;

  const Order({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.seller,
    required this.items,
    required this.delivery,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [orderId, orderNumber, status, totalAmount];
}
