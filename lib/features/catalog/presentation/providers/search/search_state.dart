import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/catalog/domain/entities/product.dart';
import 'package:harvest_app/features/catalog/domain/entities/search_history.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.loaded(List<Product> products) = SearchLoaded;
  const factory SearchState.error(String message) = SearchError;
}

@freezed
class RecentSearchesState with _$RecentSearchesState {
  const factory RecentSearchesState.initial() = RecentSearchesInitial;
  const factory RecentSearchesState.loading() = RecentSearchesLoading;
  const factory RecentSearchesState.loaded(List<SearchHistory> searches) = RecentSearchesLoaded;
  const factory RecentSearchesState.error(String message) = RecentSearchesError;
}
