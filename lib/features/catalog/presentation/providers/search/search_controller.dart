import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/providers/db_provider.dart';
import '../../../../../core/providers/dio_provider.dart';
import '../../../data/datasources/remote/search_remote_datasource.dart';
import '../../../data/datasources/local/search_local_datasource.dart';
import '../../../data/repositories/search_repository_impl.dart';
import '../../../domain/repositories/search_repository.dart';
import '../../../domain/usecases/search/clear_recent_searches.dart';
import '../../../domain/usecases/search/delete_recent_search.dart';
import '../../../domain/usecases/search/get_recent_searches.dart';
import '../../../domain/usecases/search/search_products.dart';
import 'search_state.dart';

part 'search_controller.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));

  return SearchRepositoryImpl(
    remoteDataSource: SearchRemoteDataSourceImpl(dio: dio),
    localDataSource: SearchLocalDataSourceImpl(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    ),
  );
}

@riverpod
SearchProducts searchProductsUseCase(Ref ref) {
  return SearchProducts(ref.watch(searchRepositoryProvider));
}

@riverpod
GetRecentSearches getRecentSearchesUseCase(Ref ref) {
  return GetRecentSearches(ref.watch(searchRepositoryProvider));
}

@riverpod
ClearRecentSearches clearRecentSearchesUseCase(Ref ref) {
  return ClearRecentSearches(ref.watch(searchRepositoryProvider));
}

@riverpod
DeleteRecentSearch deleteRecentSearchUseCase(Ref ref) {
  return DeleteRecentSearch(ref.watch(searchRepositoryProvider));
}

// UI State Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final showAllRecentProvider = StateProvider<bool>((ref) => false);
final sortByProvider = StateProvider<String>((ref) => 'relevance');
enum ViewMode { grid, list }
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grid);

// Filter Providers
final minPriceProvider = StateProvider<double?>((ref) => null);
final maxPriceProvider = StateProvider<double?>((ref) => null);
final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);
final selectedTypesProvider = StateProvider<List<String>>((ref) => []);

@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() {
    return const SearchState.initial();
  }

  Future<void> searchProducts() async {
    final query = ref.read(searchQueryProvider);

    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    state = const SearchState.loading();

    final sortBy = ref.read(sortByProvider);
    final minPrice = ref.read(minPriceProvider);
    final maxPrice = ref.read(maxPriceProvider);
    final categories = ref.read(selectedCategoriesProvider);
    final types = ref.read(selectedTypesProvider);

    final result = await ref.read(searchProductsUseCaseProvider).call(
      query: query,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      categories: categories.isEmpty ? null : categories,
      types: types.isEmpty ? null : types,
    );

    result.fold(
      (failure) => state = SearchState.error(failure.message),
      (products) async {
        state = SearchState.loaded(products);
        ref.read(recentSearchesControllerProvider.notifier).loadRecentSearches();
      },
    );
  }

  void clearSearch() {
    ref.read(searchQueryProvider.notifier).state = '';
    state = const SearchState.initial();
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    ref.read(searchQueryProvider.notifier).state = query;
    await searchProducts();
  }

  Future<void> applyRecentSearch(String query) async {
    ref.read(searchQueryProvider.notifier).state = query;
    await searchProducts();
  }

  Future<void> updateSort(String sortBy) async {
    ref.read(sortByProvider.notifier).state = sortBy;

    final query = ref.read(searchQueryProvider);
    if (query.trim().isNotEmpty) {
      await searchProducts();
    }
  }

  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    required List<String> categories,
    required List<String> types,
  }) async {
    ref.read(minPriceProvider.notifier).state = minPrice;
    ref.read(maxPriceProvider.notifier).state = maxPrice;
    ref.read(selectedCategoriesProvider.notifier).state = categories;
    ref.read(selectedTypesProvider.notifier).state = types;

    final query = ref.read(searchQueryProvider);
    if (query.trim().isNotEmpty) {
      await searchProducts();
    }
  }
}

@riverpod
class RecentSearchesController extends _$RecentSearchesController {
  @override
  RecentSearchesState build() {
    Future.microtask(() => loadRecentSearches());
    return const RecentSearchesState.initial();
  }

  Future<void> loadRecentSearches() async {
    state = const RecentSearchesState.loading();

    final result = await ref.read(getRecentSearchesUseCaseProvider).call();

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (searches) => state = RecentSearchesState.loaded(searches),
    );
  }

  Future<void> clearAll() async {
    final result = await ref.read(clearRecentSearchesUseCaseProvider).call();

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (_) => state = const RecentSearchesState.loaded([]),
    );
  }

  Future<void> removeSearch(String id) async {
    final result = await ref.read(deleteRecentSearchUseCaseProvider).call(id);

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (_) => loadRecentSearches(),
    );
  }
}
