import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/farmer_order.dart';

part 'farmer_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FarmerOrderModel {
  final String id;
  @JsonKey(name: 'order_number')
  final String orderNumber;
  final String status;
  @JsonKey(name: 'buyer_name')
  final String? buyerName;
  @JsonKey(name: 'buyer_avatar')
  final String? buyerAvatar;
  @JsonKey(name: 'first_item')
  final FarmerOrderFirstItemModel? firstItem;
  @JsonKey(name: 'items_count')
  final int? itemsCount;
  @JsonKey(name: 'total_amount')
  final num totalAmount;
  @JsonKey(name: 'delivery_method')
  final String? deliveryMethod;

  FarmerOrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.buyerName,
    this.buyerAvatar,
    this.firstItem,
    this.itemsCount,
    required this.totalAmount,
    this.deliveryMethod,
  });

  factory FarmerOrderModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerOrderModelToJson(this);

  FarmerOrder toEntity() {
    return FarmerOrder(
      id: id,
      orderNumber: orderNumber,
      status: status,
      buyerName: buyerName ?? 'Unknown',
      buyerPhone: '',
      items: firstItem != null 
          ? [FarmerOrderItem(productName: firstItem!.name, quantity: itemsCount ?? 1, subtotal: totalAmount.toDouble())] 
          : [],
      totalAmount: totalAmount.toDouble(),
      deliveryMethod: deliveryMethod ?? 'direct',
    );
  }
}

@JsonSerializable()
class FarmerOrderFirstItemModel {
  final String name;
  final String? image;

  FarmerOrderFirstItemModel({
    required this.name,
    this.image,
  });

  factory FarmerOrderFirstItemModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerOrderFirstItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerOrderFirstItemModelToJson(this);
}
