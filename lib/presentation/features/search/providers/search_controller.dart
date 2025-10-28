import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/db_provider.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../data/datasources/remote/search_remote_datasource.dart';
import '../../../../data/repositories/search_repository_impl.dart';
import '../../../../domain/repositories/search_repository.dart';
import '../../../../domain/usecases/search/clear_recent_searches.dart';
import '../../../../domain/usecases/search/get_recent_searches.dart';
import '../../../../domain/usecases/search/save_recent_search.dart';
import '../../../../domain/usecases/search/search_products.dart';
import '../../../../domain/entities/product.dart';
import 'search_state.dart';

// Data Source Provider
final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return SearchRemoteDataSourceImpl(dio: dio);
});

// Repository Provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.watch(searchRemoteDataSourceProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return SearchRepositoryImpl(
    remoteDataSource: remoteDataSource,
    sharedPreferences: sharedPreferences,
  );
});

// Use Case Providers
final searchProductsUseCaseProvider = Provider<SearchProducts>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchProducts(repository);
});

final getRecentSearchesUseCaseProvider = Provider<GetRecentSearches>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return GetRecentSearches(repository);
});

final saveRecentSearchUseCaseProvider = Provider<SaveRecentSearch>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SaveRecentSearch(repository);
});

final clearRecentSearchesUseCaseProvider = Provider<ClearRecentSearches>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return ClearRecentSearches(repository);
});

// UI State Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final showAllRecentProvider = StateProvider<bool>((ref) => false);
final sortByProvider = StateProvider<String>((ref) => 'relevance');
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grid);

enum ViewMode { grid, list }

// Filter Providers
final minPriceProvider = StateProvider<double?>((ref) => null);
final maxPriceProvider = StateProvider<double?>((ref) => null);
final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);
final selectedTypesProvider = StateProvider<List<String>>((ref) => []);

// Search Controller
class SearchController extends StateNotifier<SearchState> {
  final SearchProducts searchProductsUseCase;
  final SaveRecentSearch saveRecentSearchUseCase;
  final Ref ref;

  SearchController({
    required this.searchProductsUseCase,
    required this.saveRecentSearchUseCase,
    required this.ref,
  }) : super(const SearchState.initial());

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

    final result = await searchProductsUseCase(
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
        await saveRecentSearchUseCase(query);
        ref
            .read(recentSearchesControllerProvider.notifier)
            .loadRecentSearches();
      },
    );
  }

  void clearSearch() {
    ref.read(searchQueryProvider.notifier).state = '';
    state = const SearchState.initial();
  }

  // NEW: Perform search with a specific query
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    ref.read(searchQueryProvider.notifier).state = query;
    await searchProducts();
  }

  // NEW: Apply a recent search
  Future<void> applyRecentSearch(String query) async {
    ref.read(searchQueryProvider.notifier).state = query;
    await searchProducts();
  }

  // NEW: Update sort and re-search if needed
  Future<void> updateSort(String sortBy) async {
    ref.read(sortByProvider.notifier).state = sortBy;

    final query = ref.read(searchQueryProvider);
    if (query.trim().isNotEmpty) {
      await searchProducts();
    }
  }

  // NEW: Apply filters and re-search
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

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
  final searchProductsUseCase = ref.watch(searchProductsUseCaseProvider);
  final saveRecentSearchUseCase = ref.watch(saveRecentSearchUseCaseProvider);

  return SearchController(
    searchProductsUseCase: searchProductsUseCase,
    saveRecentSearchUseCase: saveRecentSearchUseCase,
    ref: ref,
  );
});

// Recent Searches Controller
class RecentSearchesController extends StateNotifier<RecentSearchesState> {
  final GetRecentSearches getRecentSearchesUseCase;
  final ClearRecentSearches clearRecentSearchesUseCase;
  final SearchRepository repository;

  RecentSearchesController({
    required this.getRecentSearchesUseCase,
    required this.clearRecentSearchesUseCase,
    required this.repository,
  }) : super(const RecentSearchesState.initial()) {
    loadRecentSearches();
  }

  Future<void> loadRecentSearches() async {
    state = const RecentSearchesState.loading();

    final result = await getRecentSearchesUseCase();

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (searches) => state = RecentSearchesState.loaded(searches),
    );
  }

  Future<void> clearAll() async {
    final result = await clearRecentSearchesUseCase();

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (_) => state = const RecentSearchesState.loaded([]),
    );
  }

  Future<void> removeSearch(String query) async {
    final result = await repository.removeRecentSearch(query);

    result.fold(
      (failure) => state = RecentSearchesState.error(failure.message),
      (_) => loadRecentSearches(),
    );
  }
}

final recentSearchesControllerProvider =
    StateNotifierProvider<RecentSearchesController, RecentSearchesState>((ref) {
  final getRecentSearchesUseCase = ref.watch(getRecentSearchesUseCaseProvider);
  final clearRecentSearchesUseCase =
      ref.watch(clearRecentSearchesUseCaseProvider);
  final repository = ref.watch(searchRepositoryProvider);

  return RecentSearchesController(
    getRecentSearchesUseCase: getRecentSearchesUseCase,
    clearRecentSearchesUseCase: clearRecentSearchesUseCase,
    repository: repository,
  );
});
