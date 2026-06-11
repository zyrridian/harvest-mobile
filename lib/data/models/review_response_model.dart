import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review_response.dart';
import 'review_model.dart';

part 'review_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewResponseModel {
  final List<ReviewModel> reviews;
  final PaginationModel pagination;

  ReviewResponseModel({
    required this.reviews,
    required this.pagination,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) => _$ReviewResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewResponseModelToJson(this);

  ReviewResponse toEntity() => ReviewResponse(
        reviews: reviews.map((e) => e.toEntity()).toList(),
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
  @JsonKey(name: 'items_per_page')
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
