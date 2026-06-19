import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/cart.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = CartInitial;
  const factory CartState.loading() = CartLoading;
  const factory CartState.data(Cart cart) = CartData;
  const factory CartState.error(String message) = CartError;
}
