import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/get_favorites_usecase.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/remove_favorite_by_id_usecase.dart';
import 'package:harvest_app/presentation/features/product/providers/product_detail_controller.dart';
import 'favorite_products_state.dart';

part 'favorite_products_controller.g.dart';

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(ref.watch(productRepositoryProvider));
});

final removeFavoriteByIdUseCaseProvider = Provider<RemoveFavoriteByIdUseCase>((ref) {
  return RemoveFavoriteByIdUseCase(ref.watch(productRepositoryProvider));
});

@riverpod
class FavoriteProductsController extends _$FavoriteProductsController {
  @override
  FavoriteProductsState build() {
    _fetchFavorites();
    return const FavoriteProductsState.loading();
  }

  Future<void> _fetchFavorites() async {
    state = const FavoriteProductsState.loading();
    final usecase = ref.read(getFavoritesUseCaseProvider);
    final result = await usecase.call();
    result.fold(
      (failure) => state = FavoriteProductsState.error(failure.message),
      (data) => state = FavoriteProductsState.data(data),
    );
  }

  Future<void> removeFavorite(String favoriteId) async {
    final usecase = ref.read(removeFavoriteByIdUseCaseProvider);
    final result = await usecase.call(favoriteId);
    result.fold(
      (failure) {
        // Option to handle failure, typically show a snackbar in UI
      },
      (_) {
        // Refresh after removing
        _fetchFavorites();
      },
    );
  }

  Future<void> refresh() async {
    await _fetchFavorites();
  }
}
