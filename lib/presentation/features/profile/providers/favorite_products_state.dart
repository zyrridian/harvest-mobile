import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/catalog/domain/entities/favorite_product.dart';

part 'favorite_products_state.freezed.dart';

@freezed
class FavoriteProductsState with _$FavoriteProductsState {
  const factory FavoriteProductsState.initial() = FavoriteProductsInitial;
  const factory FavoriteProductsState.loading() = FavoriteProductsLoading;
  const factory FavoriteProductsState.data(FavoriteProductList data) = FavoriteProductsData;
  const factory FavoriteProductsState.error(String message) = FavoriteProductsError;
}
