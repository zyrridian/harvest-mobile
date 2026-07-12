import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../../../../domain/entities/farmer.dart';
import '../entities/search_history.dart';
import '../entities/search_suggestion.dart';

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

  /// Search farmers with filters
  Future<Either<Failure, List<Farmer>>> searchFarmers({
    required String query,
    String? specialties,
    double? minRating,
    int? page,
    int? limit,
  });

  /// Get recent searches from backend
  Future<Either<Failure, List<SearchHistory>>> getRecentSearches({int? limit});

  /// Clear all recent searches
  Future<Either<Failure, void>> clearRecentSearches();

  /// Remove a specific recent search by id
  Future<Either<Failure, void>> removeRecentSearch(String id);

  /// Get search suggestions from backend
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    required String query,
    String? type,
    int? limit,
  });
}
