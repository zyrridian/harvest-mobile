import 'package:equatable/equatable.dart';
import 'review.dart';

class ProductReviewSummary extends Equatable {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;

  const ProductReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingDistribution];
}

class ReviewResponse extends Equatable {
  final List<Review> reviews;
  final ProductReviewSummary summary;
  final ReviewPagination pagination;

  const ReviewResponse({
    required this.reviews,
    required this.summary,
    required this.pagination,
  });

  @override
  List<Object?> get props => [reviews, summary, pagination];
}

class ReviewPagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  const ReviewPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, itemsPerPage];
}
