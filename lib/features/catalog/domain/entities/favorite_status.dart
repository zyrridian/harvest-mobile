import 'package:equatable/equatable.dart';

class FavoriteStatus extends Equatable {
  final String productId;
  final bool isFavorited;

  const FavoriteStatus({
    required this.productId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [productId, isFavorited];
}
