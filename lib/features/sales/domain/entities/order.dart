import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String orderItemId;
  final String productId;
  final String name;
  final int quantity;
  final num unitPrice;
  final num discount;
  final num subtotal;
  final String? imageUrl;

  const OrderItem({
    required this.orderItemId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.subtotal,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [orderItemId, productId, quantity, subtotal];
}

class OrderCounterparty extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final String role;

  const OrderCounterparty(
      {required this.userId, required this.name, this.profilePicture, required this.role});

  @override
  List<Object?> get props => [userId, name, role];
}

class OrderDelivery extends Equatable {
  final String method;
  final String? address;
  final String? date;
  final String? timeSlot;
  final num fee;
  final double? latitude;
  final double? longitude;
  final String? notes;

  const OrderDelivery(
      {required this.method,
      this.address,
      this.date,
      this.timeSlot,
      this.fee = 0,
      this.latitude,
      this.longitude,
      this.notes});

  @override
  List<Object?> get props => [method, address, date, latitude, longitude, notes];
}

class Order extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final OrderCounterparty counterparty;
  final List<OrderItem> items;
  final OrderDelivery delivery;
  final num totalAmount;
  final String? paymentUrl;

  const Order({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.counterparty,
    required this.items,
    required this.delivery,
    required this.totalAmount,
    this.paymentUrl,
  });

  @override
  List<Object?> get props => [orderId, orderNumber, status, totalAmount, paymentUrl];
}
