import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../data/datasources/remote/farmer_products_remote_datasource.dart';
import '../../../../data/repositories/farmer_products_repository_impl.dart';
import '../../../../domain/repositories/farmer_products_repository.dart';
import '../../../../domain/usecases/products/get_farmer_products.dart';
import '../../../../domain/usecases/products/get_farmer_reviews.dart';
import '../../community/providers/community_providers.dart' hide dioProvider; // To reuse the community repository provider
import 'farmer_detail_state.dart';

part 'farmer_detail_controller.g.dart';

// Providers for FarmerProducts
@riverpod
FarmerProductsRepository farmerProductsRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final dataSource = FarmerProductsRemoteDataSourceImpl(dio: dio);
  return FarmerProductsRepositoryImpl(remoteDataSource: dataSource);
}

@riverpod
GetFarmerProducts getFarmerProductsUseCase(Ref ref) {
  return GetFarmerProducts(ref.watch(farmerProductsRepositoryProvider));
}

@riverpod
GetFarmerReviews getFarmerReviewsUseCase(Ref ref) {
  return GetFarmerReviews(ref.watch(farmerProductsRepositoryProvider));
}

// Controller
@riverpod
class FarmerDetailController extends _$FarmerDetailController {
  @override
  FarmerDetailState build(String farmerId) {
    Future.microtask(() => _loadAll());
    return const FarmerDetailState();
  }

  Future<void> _loadAll() async {
    loadProducts();
    loadPosts();
    loadReviews();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(products: const AsyncValue.loading());
    final useCase = ref.read(getFarmerProductsUseCaseProvider);
    final result = await useCase(farmerId);

    result.fold(
      (failure) => state = state.copyWith(
          products: AsyncValue.error(failure.message, StackTrace.current)),
      (paginated) => state = state.copyWith(
          products: AsyncValue.data(paginated.data)),
    );
  }

  Future<void> loadPosts() async {
    state = state.copyWith(posts: const AsyncValue.loading());
    final useCase = ref.read(getFarmerPostsUseCaseProvider);
    final result = await useCase(farmerId);

    result.fold(
      (failure) => state = state.copyWith(
          posts: AsyncValue.error(failure.message, StackTrace.current)),
      (paginated) => state = state.copyWith(
          posts: AsyncValue.data(paginated.data)),
    );
  }

  Future<void> loadReviews() async {
    state = state.copyWith(reviews: const AsyncValue.loading());
    final useCase = ref.read(getFarmerReviewsUseCaseProvider);
    final result = await useCase(farmerId);

    result.fold(
      (failure) => state = state.copyWith(
          reviews: AsyncValue.error(failure.message, StackTrace.current)),
      (paginated) => state = state.copyWith(
          reviews: AsyncValue.data(paginated.data)),
    );
  }
}
