// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerDetailModel _$FarmerDetailModelFromJson(Map<String, dynamic> json) =>
    FarmerDetailModel(
      farmer: FarmerModel.fromJson(json['farmer'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      posts: FarmerDetailModel._parsePosts(json['posts'] as List?),
    );

Map<String, dynamic> _$FarmerDetailModelToJson(FarmerDetailModel instance) =>
    <String, dynamic>{
      'farmer': instance.farmer,
      'products': instance.products,
      'reviews': instance.reviews,
      'posts': FarmerDetailModel._postsToJson(instance.posts),
    };
