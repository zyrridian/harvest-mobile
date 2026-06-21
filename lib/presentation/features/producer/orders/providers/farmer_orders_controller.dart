import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/usecases/producer/get_farmer_orders_usecase.dart';
import '../../dashboard/providers/farmer_dashboard_controller.dart';
import 'farmer_orders_state.dart';

part 'farmer_orders_controller.g.dart';

@riverpod
GetFarmerOrdersUseCase getFarmerOrdersUseCase(Ref ref) {
  return GetFarmerOrdersUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmerOrdersController extends _$FarmerOrdersController {
  @override
  FarmerOrdersState build({String status = 'all'}) {
    _fetchOrders();
    return const FarmerOrdersState.loading();
  }

  Future<void> _fetchOrders() async {
    state = const FarmerOrdersState.loading();
    
    final result = await ref.read(getFarmerOrdersUseCaseProvider).call(status: status);

    result.fold(
      (failure) => state = FarmerOrdersState.error(failure.message),
      (orders) => state = FarmerOrdersState.data(orders),
    );
  }

  Future<void> refresh() async {
    await _fetchOrders();
  }
}
