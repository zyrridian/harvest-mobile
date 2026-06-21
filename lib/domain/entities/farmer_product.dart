import 'package:equatable/equatable.dart';

class FarmerProduct extends Equatable {
  final String id;
  final String name;
  final double price;
  final String unit;
  final int stock;
  final bool isAvailable;
  final String imageUrl;
  final int ordersCount;

  const FarmerProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.stock,
    required this.isAvailable,
    required this.imageUrl,
    required this.ordersCount,
  });

  FarmerProduct copyWith({
    String? id,
    String? name,
    double? price,
    String? unit,
    int? stock,
    bool? isAvailable,
    String? imageUrl,
    int? ordersCount,
  }) {
    return FarmerProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      ordersCount: ordersCount ?? this.ordersCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        unit,
        stock,
        isAvailable,
        imageUrl,
        ordersCount,
      ];
}
