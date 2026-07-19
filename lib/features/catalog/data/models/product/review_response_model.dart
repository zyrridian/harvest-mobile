import 'package:json_annotation/json_annotation.dart';
import '../../../../community/domain/entities/review_response.dart';
import 'review_model.dart';

part 'review_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductReviewSummaryModel extends ProductReviewSummary {
  @JsonKey(name: 'average_rating')
  final double averageRatingModel;
  @JsonKey(name: 'total_reviews')
  final int totalReviewsModel;
  @JsonKey(name: 'rating_distribution')
  final Map<String, int> ratingDistributionModel;

  const ProductReviewSummaryModel({
    required this.averageRatingModel,
    required this.totalReviewsModel,
    required this.ratingDistributionModel,
  }) : super(
          averageRating: averageRatingModel,
          totalReviews: totalReviewsModel,
          ratingDistribution: ratingDistributionModel,
        );

  factory ProductReviewSummaryModel.fromJson(Map<String, dynamic> json) => _$ProductReviewSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductReviewSummaryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReviewResponseModel {
  final List<ReviewModel> reviews;
  final ProductReviewSummaryModel summary;
  final PaginationModel pagination;

  ReviewResponseModel({
    required this.reviews,
    required this.summary,
    required this.pagination,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) => _$ReviewResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewResponseModelToJson(this);

  ReviewResponse toEntity() => ReviewResponse(
        reviews: reviews.map((e) => e.toEntity()).toList(),
        summary: summary,
        pagination: pagination.toEntity(),
      );
}

@JsonSerializable(explicitToJson: true)
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_items')
  final int totalItems;
  @JsonKey(name: 'limit')
  final int itemsPerPage;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  ReviewPagination toEntity() => ReviewPagination(
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        itemsPerPage: itemsPerPage,
      );
}
