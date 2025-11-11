import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/data/datasources/remote/cart_remote_datasource.dart';
import 'package:harvest_app/data/repositories/cart_repository_impl.dart';
import 'package:harvest_app/domain/usecases/cart/get_cart.dart';
import 'package:harvest_app/domain/usecases/cart/add_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/update_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/remove_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/select_cart_item.dart';
import 'package:harvest_app/domain/usecases/cart/clear_cart.dart';
import 'package:harvest_app/domain/usecases/cart/validate_cart.dart';

final cartRemoteDataSourceProvider = Provider((ref) => CartRemoteDataSource());
final cartRepositoryProvider = Provider((ref) =>
    CartRepositoryImpl(remote: ref.read(cartRemoteDataSourceProvider)));

final getCartUsecaseProvider =
    Provider((ref) => GetCart(ref.read(cartRepositoryProvider)));
final addCartItemUsecaseProvider =
    Provider((ref) => AddCartItem(ref.read(cartRepositoryProvider)));
final updateCartItemUsecaseProvider =
    Provider((ref) => UpdateCartItem(ref.read(cartRepositoryProvider)));
final removeCartItemUsecaseProvider =
    Provider((ref) => RemoveCartItem(ref.read(cartRepositoryProvider)));
final selectCartItemUsecaseProvider =
    Provider((ref) => SelectCartItem(ref.read(cartRepositoryProvider)));
final clearCartUsecaseProvider =
    Provider((ref) => ClearCart(ref.read(cartRepositoryProvider)));
final validateCartUsecaseProvider =
    Provider((ref) => ValidateCart(ref.read(cartRepositoryProvider)));

final cartProvider = FutureProvider((ref) async {
  final uc = ref.read(getCartUsecaseProvider);
  final res = await uc();
  return res.fold((l) => throw Exception(l.message), (r) => r);
});
