import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/data/datasources/remote/cart_remote_datasource.dart';
import 'package:harvest_app/data/repositories/cart_repository_impl.dart';
import 'package:harvest_app/domain/repositories/cart_repository.dart';
import 'package:harvest_app/domain/usecases/cart/get_cart.dart';
import 'package:harvest_app/domain/usecases/cart/add_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/remove_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/update_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/clear_cart.dart';
import 'package:harvest_app/domain/usecases/cart/validate_cart.dart';
import 'cart_state.dart';

part 'cart_controller.g.dart';

@riverpod
CartRepository cartRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return CartRepositoryImpl(
    remote: CartRemoteDataSource(dio),
  );
}

@riverpod
GetCart getCartUsecase(Ref ref) {
  return GetCart(ref.watch(cartRepositoryProvider));
}

@riverpod
AddCartItem addCartItemUsecase(Ref ref) {
  return AddCartItem(ref.watch(cartRepositoryProvider));
}

@riverpod
RemoveCartItem removeCartItemUsecase(Ref ref) {
  return RemoveCartItem(ref.watch(cartRepositoryProvider));
}

@riverpod
UpdateCartItem updateCartItemUsecase(Ref ref) {
  return UpdateCartItem(ref.watch(cartRepositoryProvider));
}

@riverpod
ClearCart clearCartUsecase(Ref ref) {
  return ClearCart(ref.watch(cartRepositoryProvider));
}

@riverpod
ValidateCart validateCartUsecase(Ref ref) {
  return ValidateCart(ref.watch(cartRepositoryProvider));
}

@riverpod
class CartController extends _$CartController {
  @override
  CartState build() {
    fetchCart();
    return const CartState.loading();
  }

  Future<void> fetchCart() async {
    state = const CartState.loading();
    final result = await ref.read(getCartUsecaseProvider).call();
    result.fold(
      (failure) => state = CartState.error(failure.message),
      (cart) => state = CartState.data(cart),
    );
  }

  Future<void> refresh() async {
    await fetchCart();
  }
}
