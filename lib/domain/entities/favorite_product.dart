import 'package:equatable/equatable.dart';

class FavoriteProduct extends Equatable {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String unit;
  final String imageUrl;
  final String farmerName;
  final bool isFresh;
  final double rating;
  final DateTime createdAt;

  const FavoriteProduct({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.farmerName,
    required this.isFresh,
    required this.rating,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        name,
        price,
        unit,
        imageUrl,
        farmerName,
        isFresh,
        rating,
        createdAt,
      ];
}

class FavoriteProductList extends Equatable {
  final List<FavoriteProduct> favorites;
  final int total;

  const FavoriteProductList({
    required this.favorites,
    required this.total,
  });

  @override
  List<Object?> get props => [favorites, total];
}
