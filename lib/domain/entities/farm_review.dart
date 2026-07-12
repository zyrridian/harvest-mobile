import 'package:equatable/equatable.dart';

class FarmReviewSummary extends Equatable {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;

  const FarmReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingDistribution];
}

class FarmReviewUser extends Equatable {
  final String name;
  final String? avatarUrl;

  const FarmReviewUser({
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, avatarUrl];
}

class FarmReviewProduct extends Equatable {
  final String id;
  final String name;
  final String? image;

  const FarmReviewProduct({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}

class FarmReview extends Equatable {
  final String id;
  final int rating;
  final String title;
  final String comment;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final DateTime createdAt;
  final FarmReviewUser user;
  final FarmReviewProduct product;

  const FarmReview({
    required this.id,
    required this.rating,
    required this.title,
    required this.comment,
    required this.isVerifiedPurchase,
    required this.helpfulCount,
    required this.createdAt,
    required this.user,
    required this.product,
  });

  @override
  List<Object?> get props => [
        id,
        rating,
        title,
        comment,
        isVerifiedPurchase,
        helpfulCount,
        createdAt,
        user,
        product,
      ];
}

class FarmReviewResponse extends Equatable {
  final FarmReviewSummary summary;
  final List<FarmReview> reviews;

  const FarmReviewResponse({
    required this.summary,
    required this.reviews,
  });

  @override
  List<Object?> get props => [summary, reviews];
}
