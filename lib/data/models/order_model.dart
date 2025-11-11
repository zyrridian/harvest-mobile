import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/domain/entities/order.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItemModel {
  @JsonKey(name: 'order_item_id')
  final String orderItemId;
  @JsonKey(name: 'product')
  final Map<String, dynamic> product;
  final int quantity;
  @JsonKey(name: 'unit_price')
  final int unitPrice;
  final int discount;
  final int subtotal;

  OrderItemModel({
    required this.orderItemId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  OrderItem toEntity() => OrderItem(
        orderItemId: orderItemId,
        productId: product['product_id'] ?? '',
        name: product['name'] ?? '',
        quantity: quantity,
        unitPrice: unitPrice,
        discount: discount,
        subtotal: subtotal,
      );
}

@JsonSerializable(explicitToJson: true)
class OrderSellerModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  OrderSellerModel(
      {required this.userId, required this.name, this.profilePicture});

  factory OrderSellerModel.fromJson(Map<String, dynamic> json) =>
      _$OrderSellerModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSellerModelToJson(this);

  OrderSeller toEntity() =>
      OrderSeller(userId: userId, name: name, profilePicture: profilePicture);
}

@JsonSerializable(explicitToJson: true)
class OrderDeliveryModel {
  final String method;
  final Map<String, dynamic>? address;
  final String? date;
  @JsonKey(name: 'time_slot')
  final String? timeSlot;
  final int fee;

  OrderDeliveryModel(
      {required this.method,
      this.address,
      this.date,
      this.timeSlot,
      this.fee = 0});

  factory OrderDeliveryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDeliveryModelToJson(this);

  OrderDelivery toEntity() => OrderDelivery(
      method: method,
      address: address?['full_address'] ?? address?['address'],
      date: date,
      timeSlot: timeSlot,
      fee: fee);
}

@JsonSerializable(explicitToJson: true)
class OrderModel {
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  final OrderSellerModel seller;
  final List<OrderItemModel> items;
  final OrderDeliveryModel delivery;
  @JsonKey(name: 'total_amount')
  final int totalAmount;

  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.seller,
    required this.items,
    required this.delivery,
    required this.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Order toEntity() => Order(
        orderId: orderId,
        orderNumber: orderNumber,
        status: status,
        seller: seller.toEntity(),
        items: items.map((e) => e.toEntity()).toList(),
        delivery: delivery.toEntity(),
        totalAmount: totalAmount,
      );
}
