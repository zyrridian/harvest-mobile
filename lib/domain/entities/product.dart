import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String storeName;
  final String storeId;
  final double distance; // in km
  final double price;
  final String unit; // per kg, per pcs, etc.
  final double rating;
  final int stock;
  final String? tag; // Organic, Fresh, New
  final String imageUrl;
  final String category; // Vegetables, Fruits, Grains, Dairy
  final List<String> types; // Organic, Fresh, Local
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.storeName,
    required this.storeId,
    required this.distance,
    required this.price,
    required this.unit,
    required this.rating,
    required this.stock,
    this.tag,
    required this.imageUrl,
    required this.category,
    required this.types,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        storeName,
        storeId,
        distance,
        price,
        unit,
        rating,
        stock,
        tag,
        imageUrl,
        category,
        types,
        createdAt,
      ];
}
