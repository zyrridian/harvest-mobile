import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/favorite_status.dart';

part 'favorite_status_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteStatusModel {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'is_favorited')
  final bool isFavorited;

  FavoriteStatusModel({
    required this.productId,
    required this.isFavorited,
  });

  factory FavoriteStatusModel.fromJson(Map<String, dynamic> json) => _$FavoriteStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteStatusModelToJson(this);

  FavoriteStatus toEntity() => FavoriteStatus(
        productId: productId,
        isFavorited: isFavorited,
      );
}
