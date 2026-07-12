import 'package:harvest_app/domain/entities/farm_review.dart';

class FarmReviewSummaryModel extends FarmReviewSummary {
  const FarmReviewSummaryModel({
    required super.averageRating,
    required super.totalReviews,
    required super.ratingDistribution,
  });

  factory FarmReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    final ratingDist = json['rating_distribution'] as Map<String, dynamic>? ?? {};
    final distribution = ratingDist.map((key, value) => MapEntry(key, value as int));

    return FarmReviewSummaryModel(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      ratingDistribution: distribution,
    );
  }
}

class FarmReviewUserModel extends FarmReviewUser {
  const FarmReviewUserModel({
    required super.name,
    super.avatarUrl,
  });

  factory FarmReviewUserModel.fromJson(Map<String, dynamic> json) {
    return FarmReviewUserModel(
      name: json['name'] as String? ?? 'Unknown User',
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class FarmReviewProductModel extends FarmReviewProduct {
  const FarmReviewProductModel({
    required super.id,
    required super.name,
    super.image,
  });

  factory FarmReviewProductModel.fromJson(Map<String, dynamic> json) {
    return FarmReviewProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}

class FarmReviewModel extends FarmReview {
  const FarmReviewModel({
    required super.id,
    required super.rating,
    required super.title,
    required super.comment,
    required super.isVerifiedPurchase,
    required super.helpfulCount,
    required super.createdAt,
    required super.user,
    required super.product,
  });

  factory FarmReviewModel.fromJson(Map<String, dynamic> json) {
    return FarmReviewModel(
      id: json['id'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      user: FarmReviewUserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      product: FarmReviewProductModel.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FarmReviewResponseModel extends FarmReviewResponse {
  const FarmReviewResponseModel({
    required super.summary,
    required super.reviews,
  });

  factory FarmReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final reviewsJson = json['reviews'] as List<dynamic>? ?? [];

    return FarmReviewResponseModel(
      summary: FarmReviewSummaryModel.fromJson(summaryJson),
      reviews: reviewsJson
          .map((e) => FarmReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
