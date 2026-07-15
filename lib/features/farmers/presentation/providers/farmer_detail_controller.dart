import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../data/datasources/remote/farmer_products_remote_datasource.dart';
import '../../../../data/repositories/farmer_products_repository_impl.dart';
import '../../../../domain/repositories/farmer_products_repository.dart';
import '../../../../domain/usecases/products/get_farmer_products.dart';
import '../../../../domain/usecases/products/get_farmer_reviews.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart' hide dioProvider; // To reuse the community repository provider
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_controller.dart';
import 'package:harvest_app/features/sales/presentation/providers/cart/cart_controller.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/catalog/domain/entities/product.dart';
import 'farmers_controller.dart';
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
    loadFarmerProfile();
  }

  Future<void> loadFarmerProfile() async {
    state = state.copyWith(
      farmerDetail: const AsyncValue.loading(),
      products: const AsyncValue.loading(),
      posts: const AsyncValue.loading(),
      reviews: const AsyncValue.loading(),
    );
    
    final useCase = ref.read(getFarmerDetailByIdUseCaseProvider);
    final result = await useCase(farmerId);

    result.fold(
      (failure) {
        state = state.copyWith(
          farmerDetail: AsyncValue.error(failure.message, StackTrace.current),
          products: AsyncValue.error(failure.message, StackTrace.current),
          posts: AsyncValue.error(failure.message, StackTrace.current),
          reviews: AsyncValue.error(failure.message, StackTrace.current),
        );
      },
      (detail) {
        state = state.copyWith(
          farmerDetail: AsyncValue.data(detail.farmer),
          products: AsyncValue.data(detail.products),
          posts: AsyncValue.data(detail.posts),
          reviews: AsyncValue.data(detail.reviews),
        );
      },
    );
  }

  Future<void> toggleLike(String postId, bool isCurrentlyLiked) async {
    state.posts.maybeWhen(
      data: (posts) async {
        // Optimistic update
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return CommunityPost(
              id: post.id,
              userId: post.userId,
              farmerId: post.farmerId,
              title: post.title,
              content: post.content,
              likesCount: isCurrentlyLiked ? post.likesCount - 1 : post.likesCount + 1,
              commentsCount: post.commentsCount,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              user: post.user,
              farmer: post.farmer,
              images: post.images,
              tags: post.tags,
              isLikedByUser: !isCurrentlyLiked,
            );
          }
          return post;
        }).toList();

        state = state.copyWith(posts: AsyncValue.data(updatedPosts));

        final useCase = ref.read(togglePostLikeUseCaseProvider);
        final result = await useCase.call(postId: postId, isCurrentlyLiked: isCurrentlyLiked);

        result.fold(
          (failure) {
            // Revert on error
            state = state.copyWith(posts: AsyncValue.data(posts));
          },
          (_) {},
        );
      },
      orElse: () {},
    );
  }

  Future<void> addToCart(Product product) async {
    final useCase = ref.read(addToCartUseCaseProvider);
    final result = await useCase.call(productId: product.id, quantity: 1);

    result.fold(
      (failure) {
        // Handle error if needed
      },
      (cartData) {
        // Refresh cart state to update the global Cart UI
        ref.read(cartControllerProvider.notifier).refresh();
      },
    );
  }

  Future<void> toggleFavorite(Product product) async {
    state.products.maybeWhen(
      data: (products) async {
        // Optimistic UI update
        final newIsFavorite = !product.isFavorite;

        final updatedProducts = products.map((p) {
          if (p.id == product.id) {
            return p.copyWith(isFavorite: newIsFavorite);
          }
          return p;
        }).toList();

        state = state.copyWith(products: AsyncValue.data(updatedProducts));

        if (newIsFavorite) {
          final useCase = ref.read(addFavoriteUseCaseProvider);
          final result = await useCase.call(product.id);
          result.fold((failure) {
            // Revert on error
            state = state.copyWith(products: AsyncValue.data(products));
          }, (_) {});
        } else {
          final useCase = ref.read(removeFavoriteUseCaseProvider);
          final result = await useCase.call(product.id);
          result.fold((failure) {
            // Revert on error
            state = state.copyWith(products: AsyncValue.data(products));
          }, (_) {});
        }
      },
      orElse: () {},
    );
  }
}
