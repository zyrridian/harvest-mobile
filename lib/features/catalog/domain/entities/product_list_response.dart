import 'package:equatable/equatable.dart';
import 'product_detail.dart';

class ProductListResponse extends Equatable {
  final List<ProductDetail> products;
  final PaginationData pagination;

  const ProductListResponse({
    required this.products,
    required this.pagination,
  });

  @override
  List<Object?> get props => [products, pagination];
}

class PaginationData extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  const PaginationData({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, limit];
}
