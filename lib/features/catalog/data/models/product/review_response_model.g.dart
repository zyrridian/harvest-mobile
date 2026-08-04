// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReviewSummaryModel _$ProductReviewSummaryModelFromJson(
        Map<String, dynamic> json) =>
    ProductReviewSummaryModel(
      averageRatingModel: (json['average_rating'] as num).toDouble(),
      totalReviewsModel: (json['total_reviews'] as num).toInt(),
      ratingDistributionModel:
          Map<String, int>.from(json['rating_distribution'] as Map),
    );

Map<String, dynamic> _$ProductReviewSummaryModelToJson(
        ProductReviewSummaryModel instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRatingModel,
      'total_reviews': instance.totalReviewsModel,
      'rating_distribution': instance.ratingDistributionModel,
    };

ReviewResponseModel _$ReviewResponseModelFromJson(Map<String, dynamic> json) =>
    ReviewResponseModel(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: ProductReviewSummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewResponseModelToJson(
        ReviewResponseModel instance) =>
    <String, dynamic>{
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
      'summary': instance.summary.toJson(),
      'pagination': instance.pagination.toJson(),
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      itemsPerPage: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'total_items': instance.totalItems,
      'limit': instance.itemsPerPage,
    };
