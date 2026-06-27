// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponseModel _$ReviewResponseModelFromJson(Map<String, dynamic> json) =>
    ReviewResponseModel(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewResponseModelToJson(
        ReviewResponseModel instance) =>
    <String, dynamic>{
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      itemsPerPage: (json['items_per_page'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'total_items': instance.totalItems,
      'items_per_page': instance.itemsPerPage,
    };
