import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_detail.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = ProductDetailInitial;
  const factory ProductDetailState.loading() = ProductDetailLoading;
  const factory ProductDetailState.data(
    ProductDetail product,
    bool isFavorite,
    int quantity,
    bool isInCart,
  ) = ProductDetailData;
  const factory ProductDetailState.error(String message) = ProductDetailError;
}
