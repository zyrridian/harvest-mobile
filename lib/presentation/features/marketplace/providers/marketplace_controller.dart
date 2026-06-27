import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/cart.dart';
import 'package:harvest_app/presentation/features/cart/providers/cart_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/data/datasources/local/marketplace_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/marketplace_remote_datasource.dart';
import 'package:harvest_app/data/repositories/marketplace_repository_impl.dart';
import 'package:harvest_app/domain/repositories/marketplace_repository.dart';
import 'package:harvest_app/domain/usecases/cart/add_to_cart_usecase.dart';
import 'package:harvest_app/domain/usecases/marketplace/get_marketplace_data_usecase.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/add_favorite_usecase.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/remove_favorite_usecase.dart';
import 'package:harvest_app/presentation/features/product/providers/product_detail_controller.dart';
import 'marketplace_state.dart';

part 'marketplace_controller.g.dart';

// Dependency Injection Providers
final marketplaceRemoteDataSourceProvider =
    Provider<MarketplaceRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return MarketplaceRemoteDataSourceImpl(dio);
});

final marketplaceLocalDataSourceProvider =
    Provider<MarketplaceLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));
  return MarketplaceLocalDataSourceImpl(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
});

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepositoryImpl(
    remoteDataSource: ref.watch(marketplaceRemoteDataSourceProvider),
    localDataSource: ref.watch(marketplaceLocalDataSourceProvider),
  );
});

final getMarketplaceDataUseCaseProvider =
    Provider<GetMarketplaceDataUseCase>((ref) {
  return GetMarketplaceDataUseCase(ref.watch(marketplaceRepositoryProvider));
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return AddToCartUseCase(ref.watch(marketplaceRepositoryProvider));
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  return AddFavoriteUseCase(ref.watch(productRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(ref.watch(productRepositoryProvider));
});

@riverpod
class MarketplaceController extends _$MarketplaceController {
  @override
  MarketplaceState build() {
    _fetchData();
    return const MarketplaceState.loading();
  }

  Future<void> _fetchData({String? filter, String? search}) async {
    state = const MarketplaceState.loading();

    final usecase = ref.read(getMarketplaceDataUseCaseProvider);
    
    // Fetch both marketplace data and cart data concurrently
    final results = await Future.wait([
      usecase.call(filter: filter, search: search),
      ref.read(getCartUsecaseProvider).call(),
    ]);

    final result = results[0] as Either<Failure, MarketplaceResponseEntity>;
    final cartResult = results[1] as Either<Failure, Cart>;

    int cartItemCount = 0;
    double cartTotal = 0.0;

    cartResult.fold(
      (_) {}, // Ignore failure and default to 0
      (cart) {
        cartItemCount = cart.summary.totalItems;
        cartTotal = cart.summary.subtotal.toDouble();
      },
    );

    result.fold(
      (failure) {
        state = MarketplaceState.error(failure.message);
      },
      (entity) {
        state = MarketplaceState.data(MarketplaceData.fromResponseEntity(
          entity,
          selectedFilter: filter ?? 'All',
          cartItemCount: cartItemCount,
          cartTotal: cartTotal,
        ));
      },
    );
  }

  void selectFilter(String filter) {
    state.maybeWhen(
      data: (data) {
        // Update UI state immediately
        state = MarketplaceState.data(data.copyWith(selectedFilter: filter));
        // Optionally fetch new data based on filter:
        _fetchData(filter: filter);
      },
      orElse: () {},
    );
  }

  void searchProducts(String query) {
    state.maybeWhen(
      data: (data) {
        _fetchData(filter: data.selectedFilter, search: query);
      },
      orElse: () {
        _fetchData(search: query);
      },
    );
  }

  Future<void> addToCart(MarketplaceProduct product) async {
    state.maybeWhen(
      data: (data) async {
        // Optimistic UI update
        state = MarketplaceState.data(data.copyWith(
          cartItemCount: data.cartItemCount + 1,
          cartTotal: data.cartTotal + product.price,
        ));

        final usecase = ref.read(addToCartUseCaseProvider);
        final result = await usecase.call(productId: product.id, quantity: 1);

        result.fold(
          (failure) {
            // Error handling: optionally revert the state or show an error message
          },
          (cartData) {
            // Update state with actual data from backend if needed
            state = state.maybeMap(
              data: (curr) => MarketplaceState.data(curr.data.copyWith(
                cartItemCount: cartData['cart_item_count'] as int,
                cartTotal: (cartData['cart_total'] as num).toDouble(),
              )),
              orElse: () => state,
            );
          },
        );
      },
      orElse: () {},
    );
  }

  Future<void> toggleFavorite(MarketplaceProduct product) async {
    state.maybeWhen(
      data: (data) async {
        // Optimistic UI update
        final newIsFavorite = !product.isFavorite;

        final updatedProducts = data.products.map((p) {
          if (p.id == product.id) {
            return MarketplaceProduct(
              id: p.id,
              name: p.name,
              farmerName: p.farmerName,
              price: p.price,
              unit: p.unit,
              imageUrl: p.imageUrl,
              rating: p.rating,
              soldCount: p.soldCount,
              isFresh: p.isFresh,
              isFavorite: newIsFavorite,
            );
          }
          return p;
        }).toList();

        state = MarketplaceState.data(data.copyWith(products: updatedProducts));

        if (newIsFavorite) {
          final usecase = ref.read(addFavoriteUseCaseProvider);
          final result = await usecase.call(product.id);
          result.fold((failure) {
            // Revert on failure
            _revertFavoriteStatus(product.id, data);
          }, (_) {});
        } else {
          final usecase = ref.read(removeFavoriteUseCaseProvider);
          final result = await usecase.call(product.id);
          result.fold((failure) {
            // Revert on failure
            _revertFavoriteStatus(product.id, data);
          }, (_) {});
        }
      },
      orElse: () {},
    );
  }

  void _revertFavoriteStatus(String productId, MarketplaceData originalData) {
    state.maybeWhen(
      data: (currentData) {
        final revertedProducts = currentData.products.map((p) {
          if (p.id == productId) {
            final originalProduct = originalData.products
                .firstWhere((element) => element.id == productId);
            return MarketplaceProduct(
              id: p.id,
              name: p.name,
              farmerName: p.farmerName,
              price: p.price,
              unit: p.unit,
              imageUrl: p.imageUrl,
              rating: p.rating,
              soldCount: p.soldCount,
              isFresh: p.isFresh,
              isFavorite: originalProduct.isFavorite,
            );
          }
          return p;
        }).toList();
        state = MarketplaceState.data(
            currentData.copyWith(products: revertedProducts));
      },
      orElse: () {},
    );
  }
}
