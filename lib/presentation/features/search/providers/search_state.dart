import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/product.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.loaded(List<Product> products) = _Loaded;
  const factory SearchState.error(String message) = _Error;
}

@freezed
class RecentSearchesState with _$RecentSearchesState {
  const factory RecentSearchesState.initial() = _RecentSearchesInitial;
  const factory RecentSearchesState.loading() = _RecentSearchesLoading;
  const factory RecentSearchesState.loaded(List<String> searches) =
      _RecentSearchesLoaded;
  const factory RecentSearchesState.error(String message) =
      _RecentSearchesError;
}
