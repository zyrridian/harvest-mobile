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
    final result = await ref.read(getCartUsecaseProvider).call();
    result.fold(
      (failure) {}, // Fail silently on refresh to keep existing data visible
      (cart) => state = CartState.data(cart),
    );
  }

  Future<void> updateQuantity(String cartItemId, int newQty) async {
    state.maybeWhen(
      data: (cart) {
        // Optimistic update
        final updatedItems = cart.items.map((e) {
          if (e.cartItemId == cartItemId) {
            return e.copyWith(
              quantity: newQty,
              subtotal: newQty * e.unitPrice,
            );
          }
          return e;
        }).toList();

        final optimisticCart = cart.copyWith(items: updatedItems);
        state = CartState.data(optimisticCart);

        // API Call
        ref
            .read(updateCartItemUsecaseProvider)
            .call(cartItemId: cartItemId, quantity: newQty)
            .then((res) {
          res.fold(
            (failure) => state = CartState.data(cart), // Revert on failure
            (_) => refresh(), // Sync silently with backend totals
          );
        });
      },
      orElse: () {},
    );
  }

  Future<void> removeItem(String cartItemId) async {
    state.maybeWhen(
      data: (cart) {
        // Optimistic update
        final updatedItems =
            cart.items.where((e) => e.cartItemId != cartItemId).toList();
        final optimisticCart = cart.copyWith(items: updatedItems);
        state = CartState.data(optimisticCart);

        // API Call
        ref
            .read(removeCartItemUsecaseProvider)
            .call(cartItemId: cartItemId)
            .then((res) {
          res.fold(
            (failure) => state = CartState.data(cart), // Revert
            (_) => refresh(),
          );
        });
      },
      orElse: () {},
    );
  }

  Future<void> clearCart() async {
    state.maybeWhen(
      data: (cart) {
        // Optimistic update
        final optimisticCart = cart.copyWith(items: []);
        state = CartState.data(optimisticCart);

        ref.read(clearCartUsecaseProvider).call().then((res) {
          res.fold(
            (failure) => state = CartState.data(cart), // Revert
            (_) => refresh(),
          );
        });
      },
      orElse: () {},
    );
  }
}
