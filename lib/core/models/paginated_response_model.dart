import 'package:json_annotation/json_annotation.dart';
import 'paginated_response.dart';

part 'paginated_response_model.g.dart';

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'page')
  final int currentPage;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total')
  final int totalItems;
  @JsonKey(name: 'items_per_page')
  final int? itemsPerPage;
  final int? limit;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.itemsPerPage,
    this.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  Pagination toEntity() {
    return Pagination(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      limit: limit,
    );
  }

  factory PaginationModel.fromEntity(Pagination entity) {
    return PaginationModel(
      currentPage: entity.currentPage,
      totalPages: entity.totalPages,
      totalItems: entity.totalItems,
      itemsPerPage: entity.itemsPerPage,
      limit: entity.limit,
    );
  }
}

class PaginatedResponseModel<T> {
  final String status;
  final List<T> data;
  final PaginationModel? pagination;

  PaginatedResponseModel({
    required this.status,
    required this.data,
    this.pagination,
  });

  factory PaginatedResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    List<T> dataList = [];
    PaginationModel? pagination;

    if (json['data'] is List) {
      dataList = (json['data'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList();
      if (json['pagination'] != null) {
        pagination = PaginationModel.fromJson(json['pagination']);
      }
    } else if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      // Find the first list in the map
      for (var value in dataMap.values) {
        if (value is List) {
          dataList = value
              .map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList();
          break;
        }
      }
      if (dataMap['pagination'] != null) {
        pagination = PaginationModel.fromJson(dataMap['pagination']);
      } else if (json['pagination'] != null) {
        pagination = PaginationModel.fromJson(json['pagination']);
      }
    }

    return PaginatedResponseModel<T>(
      status: json['status'] ?? 'success',
      data: dataList,
      pagination: pagination,
    );
  }

  PaginatedResponse<E> toEntity<E>(E Function(T model) mapper) {
    return PaginatedResponse<E>(
      data: data.map((e) => mapper(e)).toList(),
      pagination: pagination?.toEntity() ??
          const Pagination(
            currentPage: 1,
            totalPages: 1,
            totalItems: 0,
          ),
    );
  }
}
