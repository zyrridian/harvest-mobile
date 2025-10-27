import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 20;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  }) async {
    try {
      final productModels = await remoteDataSource.searchProducts(
        query: query,
        sortBy: sortBy,
        minPrice: minPrice,
        maxPrice: maxPrice,
        categories: categories,
        types: types,
        page: page,
        limit: limit,
      );

      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches() async {
    try {
      final searches =
          sharedPreferences.getStringList(_recentSearchesKey) ?? [];
      return Right(searches);
    } catch (e) {
      return Left(CacheFailure('Failed to get recent searches'));
    }
  }

  @override
  Future<Either<Failure, void>> saveRecentSearch(String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Right(null);
      }

      final searches =
          sharedPreferences.getStringList(_recentSearchesKey) ?? [];

      // Remove if already exists
      searches.remove(query);

      // Add to beginning
      searches.insert(0, query);

      // Keep only the last N searches
      if (searches.length > _maxRecentSearches) {
        searches.removeRange(_maxRecentSearches, searches.length);
      }

      await sharedPreferences.setStringList(_recentSearchesKey, searches);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save recent search'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() async {
    try {
      await sharedPreferences.remove(_recentSearchesKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear recent searches'));
    }
  }

  @override
  Future<Either<Failure, void>> removeRecentSearch(String query) async {
    try {
      final searches =
          sharedPreferences.getStringList(_recentSearchesKey) ?? [];
      searches.remove(query);
      await sharedPreferences.setStringList(_recentSearchesKey, searches);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove recent search'));
    }
  }
}
