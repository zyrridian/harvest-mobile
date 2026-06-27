import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'category_product_model.dart';

part 'category_response_model.g.dart';

@JsonSerializable()
class CategoryListResponse {
  final String status;
  final List<CategoryModel>? data;

  CategoryListResponse({
    required this.status,
    this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class CategoryDetailResponse {
  final String status;
  final CategoryModel? data;

  CategoryDetailResponse({
    required this.status,
    this.data,
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDetailResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class CategoryProductsResponse {
  final String status;
  final CategoryProductsData? data;

  CategoryProductsResponse({
    required this.status,
    this.data,
  });

  factory CategoryProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class CategoryProductsData {
  final List<CategoryProductModel> products;
  final PaginationModel? pagination;

  CategoryProductsData({
    required this.products,
    this.pagination,
  });

  factory CategoryProductsData.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsDataToJson(this);
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
}
