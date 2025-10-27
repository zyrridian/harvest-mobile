import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/product.dart';

abstract class SearchRepository {
  /// Search products with filters
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    String? sortBy, // relevance, price, distance, newest, rating
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  });

  /// Get recent searches
  Future<Either<Failure, List<String>>> getRecentSearches();

  /// Save recent search
  Future<Either<Failure, void>> saveRecentSearch(String query);

  /// Clear all recent searches
  Future<Either<Failure, void>> clearRecentSearches();

  /// Remove a specific recent search
  Future<Either<Failure, void>> removeRecentSearch(String query);
}
