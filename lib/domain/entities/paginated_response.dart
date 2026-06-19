import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int? itemsPerPage;
  final int? limit;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.itemsPerPage,
    this.limit,
  });

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        limit,
      ];
}

class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final Pagination pagination;

  const PaginatedResponse({
    required this.data,
    required this.pagination,
  });

  @override
  List<Object?> get props => [data, pagination];

  PaginatedResponse<T> copyWith({
    List<T>? data,
    Pagination? pagination,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
