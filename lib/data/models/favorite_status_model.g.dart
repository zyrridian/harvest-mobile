// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteStatusModel _$FavoriteStatusModelFromJson(Map<String, dynamic> json) =>
    FavoriteStatusModel(
      productId: json['product_id'] as String,
      isFavorited: json['is_favorited'] as bool,
    );

Map<String, dynamic> _$FavoriteStatusModelToJson(
        FavoriteStatusModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'is_favorited': instance.isFavorited,
    };
