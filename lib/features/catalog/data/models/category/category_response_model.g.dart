// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryListResponse _$CategoryListResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryListResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryListResponseToJson(
        CategoryListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

CategoryDetailResponse _$CategoryDetailResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryDetailResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : CategoryModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryDetailResponseToJson(
        CategoryDetailResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

CategoryProductsResponse _$CategoryProductsResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryProductsResponse(
      status: json['status'] as String,
      data: json['data'] == null
          ? null
          : CategoryProductsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryProductsResponseToJson(
        CategoryProductsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

CategoryProductsData _$CategoryProductsDataFromJson(
        Map<String, dynamic> json) =>
    CategoryProductsData(
      products: (json['products'] as List<dynamic>)
          .map((e) => CategoryProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryProductsDataToJson(
        CategoryProductsData instance) =>
    <String, dynamic>{
      'products': instance.products,
      'pagination': instance.pagination,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'total_items': instance.totalItems,
      'limit': instance.limit,
    };
