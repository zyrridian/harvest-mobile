import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../data/datasources/remote/farmer_products_remote_datasource.dart';
import '../../../../data/repositories/farmer_products_repository_impl.dart';
import '../../../../domain/repositories/farmer_products_repository.dart';
import '../../../../domain/usecases/products/get_farmer_products.dart';
import '../../../../domain/usecases/products/get_farmer_reviews.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/review.dart';
import '../../../../core/error/failures.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Data source provider
final farmerProductsDataSourceProvider =
    Provider<FarmerProductsDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return FarmerProductsRemoteDataSourceImpl(dio: dio);
});

// Repository provider
final farmerProductsRepositoryProvider =
    Provider<FarmerProductsRepository>((ref) {
  final dataSource = ref.watch(farmerProductsDataSourceProvider);
  return FarmerProductsRepositoryImpl(remoteDataSource: dataSource);
});

// Use case providers
final getFarmerProductsUseCaseProvider = Provider<GetFarmerProducts>((ref) {
  final repository = ref.watch(farmerProductsRepositoryProvider);
  return GetFarmerProducts(repository);
});

final getFarmerReviewsUseCaseProvider = Provider<GetFarmerReviews>((ref) {
  final repository = ref.watch(farmerProductsRepositoryProvider);
  return GetFarmerReviews(repository);
});

// State providers for farmer products
final farmerProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, farmerId) async {
  final useCase = ref.watch(getFarmerProductsUseCaseProvider);
  final result = await useCase(farmerId);

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (products) => products,
  );
});

// State providers for farmer reviews
final farmerReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, farmerId) async {
  final useCase = ref.watch(getFarmerReviewsUseCaseProvider);
  final result = await useCase(farmerId);

  return result.fold(
    (failure) => throw Exception(_mapFailureToMessage(failure)),
    (reviews) => reviews,
  );
});

String _mapFailureToMessage(Failure failure) {
  if (failure is ServerFailure) {
    return 'Server error: ${failure.message}';
  } else if (failure is CacheFailure) {
    return 'Cache error: ${failure.message}';
  } else if (failure is NetworkFailure) {
    return 'Network error: ${failure.message}';
  }
  return 'Unexpected error occurred';
}
