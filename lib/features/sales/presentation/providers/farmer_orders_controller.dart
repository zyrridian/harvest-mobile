import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_farmer_orders_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/update_order_status_usecase.dart';
import '../../../farmers/presentation/providers/farmer_dashboard_controller.dart';
import 'farmer_orders_state.dart';
part 'farmer_orders_controller.g.dart';

@riverpod
GetFarmerOrdersUseCase getFarmerOrdersUseCase(Ref ref) {
  return GetFarmerOrdersUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
UpdateOrderStatusUseCase updateOrderStatusUseCase(Ref ref) {
  return UpdateOrderStatusUseCase(ref.watch(producerRepositoryProvider));
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

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final previousState = state;
    
    state.maybeWhen(
      data: (orders) {
        final updatedOrders = orders.map((o) {
          if (o.id == orderId) {
            return FarmerOrder(
              id: o.id,
              orderNumber: o.orderNumber,
              status: newStatus,
              buyerName: o.buyerName,
              buyerPhone: o.buyerPhone,
              items: o.items,
              totalAmount: o.totalAmount,
              deliveryMethod: o.deliveryMethod,
              deliveryDate: o.deliveryDate,
            );
          }
          return o;
        }).toList();
        state = FarmerOrdersState.data(updatedOrders);
      },
      orElse: () {},
    );

    final result = await ref.read(updateOrderStatusUseCaseProvider).call(orderId, newStatus);
    
    result.fold(
      (failure) {
        state = previousState;
      },
      (_) {},
    );
  }
}
