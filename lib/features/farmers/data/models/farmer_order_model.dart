import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FarmerOrderModel {
  final String id;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  final FarmerOrderBuyerModel buyer;
  final List<FarmerOrderItemModel> items;
  @JsonKey(name: 'total_amount')
  final num totalAmount;
  @JsonKey(name: 'delivery_method')
  final String? deliveryMethod;
  @JsonKey(name: 'delivery_date')
  final String? deliveryDate;

  FarmerOrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.buyer,
    required this.items,
    required this.totalAmount,
    this.deliveryMethod,
    this.deliveryDate,
  });

  factory FarmerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerOrderModelToJson(this);

  FarmerOrder toEntity() {
    return FarmerOrder(
      id: id,
      orderNumber: orderNumber,
      status: status,
      buyerName: buyer.name,
      buyerPhone: buyer.phone ?? '',
      items: items.map((i) => i.toEntity()).toList(),
      totalAmount: totalAmount.toDouble(),
      deliveryMethod: deliveryMethod ?? 'direct',
      deliveryDate: deliveryDate,
    );
  }
}

@JsonSerializable()
class FarmerOrderBuyerModel {
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;

  FarmerOrderBuyerModel({
    required this.name,
    this.email,
    this.phone,
    this.avatar,
  });

  factory FarmerOrderBuyerModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerOrderBuyerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerOrderBuyerModelToJson(this);
}

@JsonSerializable()
class FarmerOrderItemModel {
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'product_image')
  final String? productImage;
  final int quantity;
  @JsonKey(name: 'subtotal')
  final num subtotal;

  FarmerOrderItemModel({
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.subtotal,
  });

  factory FarmerOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerOrderItemModelToJson(this);

  FarmerOrderItem toEntity() {
    return FarmerOrderItem(
      productName: productName,
      quantity: quantity,
      subtotal: subtotal.toDouble(),
      productImage: productImage,
    );
  }
}
