import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/catalog/data/datasources/remote/product_remote_datasource.dart';
import 'package:harvest_app/features/catalog/data/datasources/local/product_local_datasource.dart';
import 'package:harvest_app/features/catalog/data/repositories/product_repository_impl.dart';
import 'package:harvest_app/features/catalog/domain/repositories/product_repository.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/get_product_detail.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/check_favorite_status.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/add_favorite_usecase.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/remove_favorite_usecase.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/submit_product_review.dart';
import 'package:harvest_app/features/catalog/domain/usecases/product/get_product_reviews.dart';
import 'package:harvest_app/features/community/domain/entities/review_response.dart';
import 'product_detail_state.dart';

part 'product_detail_controller.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepositoryImpl(
    remoteDataSource: ProductRemoteDataSourceImpl(dio),
    localDataSource: ProductLocalDataSourceImpl(),
  );
}

@riverpod
GetProductDetail getProductDetailUseCase(Ref ref) {
  return GetProductDetail(ref.watch(productRepositoryProvider));
}

@riverpod
CheckFavoriteStatus checkFavoriteStatusUseCase(Ref ref) {
  return CheckFavoriteStatus(ref.watch(productRepositoryProvider));
}

@riverpod
AddFavoriteUseCase addFavoriteUseCase(Ref ref) {
  return AddFavoriteUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
RemoveFavoriteUseCase removeFavoriteUseCase(Ref ref) {
  return RemoveFavoriteUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
SubmitProductReview submitProductReviewUseCase(Ref ref) {
  return SubmitProductReview(ref.watch(productRepositoryProvider));
}

@riverpod
GetProductReviews getProductReviewsUseCase(Ref ref) {
  return GetProductReviews(ref.watch(productRepositoryProvider));
}

@riverpod
Future<ReviewResponse> productReviews(Ref ref, String slug) async {
  final useCase = ref.watch(getProductReviewsUseCaseProvider);
  final result = await useCase.call(slug, limit: 5);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (reviews) => reviews,
  );
}

@riverpod
class ProductDetailController extends _$ProductDetailController {
  @override
  ProductDetailState build(String slug) {
    _fetchProductData();
    return const ProductDetailState.loading();
  }

  Future<void> _fetchProductData() async {
    state = const ProductDetailState.loading();
    
    final detailResult = await ref.read(getProductDetailUseCaseProvider).call(slug);
    final favoriteResult = await ref.read(checkFavoriteStatusUseCaseProvider).call(slug);
    
    detailResult.fold(
      (failure) => state = ProductDetailState.error(failure.message),
      (product) {
        bool isFavorite = false;
        favoriteResult.fold(
          (failure) {}, 
          (status) => isFavorite = status.isFavorited,
        );
        state = ProductDetailState.data(product, isFavorite, 1, false);
      },
    );
  }

  Future<void> refresh() async {
    await _fetchProductData();
  }

  Future<void> toggleFavorite() async {
    final currentState = state;
    if (currentState is ProductDetailData) {
      final newFavoriteStatus = !currentState.isFavorite;
      // Optimistic update
      state = currentState.copyWith(isFavorite: newFavoriteStatus);
      
      final result = newFavoriteStatus 
          ? await ref.read(addFavoriteUseCaseProvider).call(currentState.product.id)
          : await ref.read(removeFavoriteUseCaseProvider).call(currentState.product.id);
          
      result.fold(
        (failure) {
          // Revert if failed
          state = currentState.copyWith(isFavorite: currentState.isFavorite);
        },
        (_) {},
      );
    }
  }

  void incrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailData) {
      if (currentState.quantity < currentState.product.stockQuantity) {
        state = currentState.copyWith(quantity: currentState.quantity + 1);
      }
    }
  }

  void decrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailData) {
      if (currentState.quantity > 1) {
        state = currentState.copyWith(quantity: currentState.quantity - 1);
      }
    }
  }

  void addToCart() {
    final currentState = state;
    if (currentState is ProductDetailData) {
      state = currentState.copyWith(isInCart: true);
    }
  }
}
