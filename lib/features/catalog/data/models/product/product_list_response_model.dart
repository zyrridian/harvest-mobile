import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/product_list_response.dart';
import 'product_detail_model.dart';

part 'product_list_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductListResponseModel {
  final List<ProductDetailModel> products;
  final PaginationModel pagination;

  ProductListResponseModel({
    required this.products,
    required this.pagination,
  });

  factory ProductListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductListResponseModelToJson(this);

  ProductListResponse toEntity() {
    return ProductListResponse(
      products: products.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_items')
  final int totalItems;
  final int limit;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  PaginationData toEntity() {
    return PaginationData(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      limit: limit,
    );
  }
}
