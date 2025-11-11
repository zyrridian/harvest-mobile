import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/product_detail_remote_datasource.dart';
import '../../data/repositories/product_detail_repository_impl.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../../domain/usecases/product/add_product_to_favorites.dart';
import '../../domain/usecases/product/get_product_detail.dart';
import '../../domain/usecases/product/remove_product_from_favorites.dart';
import '../../domain/usecases/product/track_product_view.dart';

// Data Source Provider
final productDetailDataSourceProvider =
    Provider<ProductDetailRemoteDataSource>((ref) {
  return ProductDetailRemoteDataSourceImpl();
});

// Repository Provider
final productDetailRepositoryProvider =
    Provider<ProductDetailRepository>((ref) {
  return ProductDetailRepositoryImpl(
    remoteDataSource: ref.read(productDetailDataSourceProvider),
  );
});

// Use Case Providers
final getProductDetailUseCaseProvider = Provider<GetProductDetail>((ref) {
  return GetProductDetail(ref.read(productDetailRepositoryProvider));
});

final addProductToFavoritesUseCaseProvider =
    Provider<AddProductToFavorites>((ref) {
  return AddProductToFavorites(ref.read(productDetailRepositoryProvider));
});

final removeProductFromFavoritesUseCaseProvider =
    Provider<RemoveProductFromFavorites>((ref) {
  return RemoveProductFromFavorites(ref.read(productDetailRepositoryProvider));
});

final trackProductViewUseCaseProvider = Provider<TrackProductView>((ref) {
  return TrackProductView(ref.read(productDetailRepositoryProvider));
});

// Product Detail Provider
final productDetailProvider = FutureProvider.autoDispose
    .family<ProductDetail, String>((ref, productId) async {
  final useCase = ref.read(getProductDetailUseCaseProvider);
  final result = await useCase(productId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

// Favorite State Provider
final isFavoriteProvider =
    StateProvider.autoDispose.family<bool, String>((ref, productId) {
  final productAsync = ref.watch(productDetailProvider(productId));
  return productAsync.maybeWhen(
    data: (product) => product.isFavorite,
    orElse: () => false,
  );
});

// Cart State Provider
final isInCartProvider =
    StateProvider.autoDispose.family<bool, String>((ref, productId) {
  final productAsync = ref.watch(productDetailProvider(productId));
  return productAsync.maybeWhen(
    data: (product) => product.isInCart,
    orElse: () => false,
  );
});

// Quantity State Provider
final productQuantityProvider =
    StateProvider.autoDispose.family<int, String>((ref, productId) {
  final productAsync = ref.watch(productDetailProvider(productId));
  return productAsync.maybeWhen(
    data: (product) => product.minimumOrder,
    orElse: () => 1,
  );
});
