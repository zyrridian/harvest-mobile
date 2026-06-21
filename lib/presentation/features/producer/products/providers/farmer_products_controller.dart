import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/usecases/producer/get_farmer_products_usecase.dart';
import '../../dashboard/providers/farmer_dashboard_controller.dart';
import 'farmer_products_state.dart';

part 'farmer_products_controller.g.dart';

@riverpod
GetFarmerProductsUseCase getFarmerProductsUseCase(Ref ref) {
  return GetFarmerProductsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmerProductsController extends _$FarmerProductsController {
  @override
  FarmerProductsState build() {
    _fetchProducts();
    return const FarmerProductsState.loading();
  }

  Future<void> _fetchProducts() async {
    state = const FarmerProductsState.loading();
    
    final result = await ref.read(getFarmerProductsUseCaseProvider).call();

    result.fold(
      (failure) => state = FarmerProductsState.error(failure.message),
      (products) => state = FarmerProductsState.data(products),
    );
  }

  Future<void> refresh() async {
    await _fetchProducts();
  }
}
