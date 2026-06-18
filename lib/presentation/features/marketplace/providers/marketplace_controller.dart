import 'package:dio/dio.dart';
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
    final result = await usecase.call(filter: filter, search: search);

    result.fold(
      (failure) {
        state = MarketplaceState.error(failure.message);
      },
      (entity) {
        state = MarketplaceState.data(MarketplaceData.fromResponseEntity(
          entity,
          selectedFilter: filter ?? 'All',
          cartItemCount:
              3, // Defaulting to 3 based on initial UI design. Change to 0 when backend cart syncs
          cartTotal: 91000,
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
            // state = MarketplaceState.data(data.copyWith(
            //   cartItemCount: cartData['cart_item_count'],
            //   cartTotal: (cartData['cart_total'] as num).toDouble(),
            // ));
          },
        );
      },
      orElse: () {},
    );
  }
}
