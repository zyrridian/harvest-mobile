import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/farmer.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/search_history.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/search_remote_datasource.dart';
import '../datasources/local/search_local_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
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

      final products = productModels.map<Product>((model) => model.toEntity()).toList();
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
  Future<Either<Failure, List<Farmer>>> searchFarmers({
    required String query,
    String? specialties,
    double? minRating,
    int? page,
    int? limit,
  }) async {
    try {
      final farmerModels = await remoteDataSource.searchFarmers(
        query: query,
        specialties: specialties,
        minRating: minRating,
        page: page,
        limit: limit,
      );

      final farmers = farmerModels.map<Farmer>((model) => model.toEntity()).toList();
      return Right(farmers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<SearchHistory>>> getRecentSearches({int? limit}) async {
    try {
      final searchModels = await remoteDataSource.getSearchHistory(limit: limit);
      
      // Cache the result locally
      await localDataSource.saveRecentSearches(searchModels);
      
      final searches = searchModels.map<SearchHistory>((model) => model.toEntity()).toList();
      return Right(searches);
    } on ServerException catch (e) {
      // Try to fetch from local cache if remote fails
      try {
        final localSearches = await localDataSource.getRecentSearches();
        if (localSearches != null) {
          return Right(localSearches.map<SearchHistory>((m) => m.toEntity()).toList());
        }
      } catch (_) {
        // Fallback to server failure if local fails
      }
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() async {
    try {
      await remoteDataSource.clearSearchHistory();
      await localDataSource.clearRecentSearches();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> removeRecentSearch(String id) async {
    try {
      await remoteDataSource.deleteSearchHistory(id);
      
      // Re-fetch to update cache
      try {
        final searchModels = await remoteDataSource.getSearchHistory();
        await localDataSource.saveRecentSearches(searchModels);
      } catch (_) {
        // Ignore cache update errors
      }
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    required String query,
    String? type,
    int? limit,
  }) async {
    try {
      final suggestionModels = await remoteDataSource.getSearchSuggestions(
        query: query,
        type: type,
        limit: limit,
      );

      final suggestions = suggestionModels.map<SearchSuggestion>((model) => model.toEntity()).toList();
      return Right(suggestions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
