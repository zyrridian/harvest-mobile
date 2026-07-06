import 'package:equatable/equatable.dart';
import 'review.dart';

class ReviewResponse extends Equatable {
  final List<Review> reviews;
  final ReviewPagination pagination;

  const ReviewResponse({
    required this.reviews,
    required this.pagination,
  });

  @override
  List<Object?> get props => [reviews, pagination];
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
