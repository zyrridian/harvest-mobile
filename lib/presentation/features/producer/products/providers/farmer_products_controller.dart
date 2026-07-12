import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/usecases/producer/get_farmer_products_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/get_farmer_product_detail_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/create_farmer_product_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/update_farmer_product_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/delete_farmer_product_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/toggle_farmer_product_availability_usecase.dart';
import '../../dashboard/providers/farmer_dashboard_controller.dart';
import 'farmer_products_state.dart';

part 'farmer_products_controller.g.dart';

@riverpod
GetFarmerProductsUseCase getFarmerProductsUseCase(Ref ref) {
  return GetFarmerProductsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
GetFarmerProductDetailUseCase getFarmerProductDetailUseCase(Ref ref) {
  return GetFarmerProductDetailUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
CreateFarmerProductUseCase createFarmerProductUseCase(Ref ref) {
  return CreateFarmerProductUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
UpdateFarmerProductUseCase updateFarmerProductUseCase(Ref ref) {
  return UpdateFarmerProductUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
DeleteFarmerProductUseCase deleteFarmerProductUseCase(Ref ref) {
  return DeleteFarmerProductUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
ToggleFarmerProductAvailabilityUseCase toggleFarmerProductAvailabilityUseCase(Ref ref) {
  return ToggleFarmerProductAvailabilityUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmerProductsController extends _$FarmerProductsController {
  String _currentFilter = 'all';
  String _searchQuery = '';

  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  @override
  FarmerProductsState build() {
    _fetchProducts();
    return const FarmerProductsState.loading();
  }

  Future<void> _fetchProducts({bool showLoading = true}) async {
    if (showLoading) {
      state = const FarmerProductsState.loading();
    }
    
    final result = await ref.read(getFarmerProductsUseCaseProvider).call(status: _currentFilter);

    result.fold(
      (failure) => state = FarmerProductsState.error(failure.message),
      (products) {
        if (_searchQuery.isEmpty) {
          state = FarmerProductsState.data(products);
        } else {
          final query = _searchQuery.toLowerCase();
          final filtered = products.where((p) => 
            p.name.toLowerCase().contains(query)
          ).toList();
          state = FarmerProductsState.data(filtered);
        }
      },
    );
  }

  Future<void> refresh() async {
    await _fetchProducts(showLoading: false);
  }

  Future<void> setFilter(String status) async {
    if (_currentFilter == status) return;
    _currentFilter = status;
    await _fetchProducts();
  }

  Future<void> setSearchQuery(String query) async {
    if (_searchQuery == query) return;
    _searchQuery = query;
    await _fetchProducts();
  }

  Future<bool> deleteProduct(String id) async {
    final result = await ref.read(deleteFarmerProductUseCaseProvider).call(id);
    return result.fold(
      (failure) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }

  Future<bool> toggleAvailability(String id, bool isAvailable) async {
    final result = await ref.read(toggleFarmerProductAvailabilityUseCaseProvider).call(id, isAvailable);
    return result.fold(
      (failure) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }
}
