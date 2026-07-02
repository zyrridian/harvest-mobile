import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/sales/data/datasources/local/order_local_datasource.dart';
import 'package:harvest_app/features/sales/data/datasources/remote/order_remote_datasource.dart';
import 'package:harvest_app/features/sales/data/repositories/order_repository_impl.dart';
import 'package:harvest_app/features/sales/domain/repositories/order_repository.dart';
import 'package:harvest_app/features/sales/domain/usecases/order/create_order.dart';
import 'package:harvest_app/features/sales/domain/usecases/order/get_orders.dart';
import 'package:harvest_app/features/sales/domain/usecases/order/get_order_detail.dart';
import 'package:harvest_app/features/sales/domain/usecases/order/cancel_order.dart';
import 'package:harvest_app/features/sales/domain/entities/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'order_state.dart';

part 'order_controller.g.dart';

@riverpod
OrderRepository orderRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  
  return OrderRepositoryImpl(
    remote: OrderRemoteDataSourceImpl(dio),
    local: OrderLocalDataSourceImpl(sharedPreferences),
  );
}

@riverpod
GetOrders getOrdersUsecase(Ref ref) {
  return GetOrders(ref.watch(orderRepositoryProvider));
}

@riverpod
GetOrderDetail getOrderDetailUsecase(Ref ref) {
  return GetOrderDetail(ref.watch(orderRepositoryProvider));
}

@riverpod
CreateOrder createOrderUsecase(Ref ref) {
  return CreateOrder(ref.watch(orderRepositoryProvider));
}

@riverpod
CancelOrder cancelOrderUsecase(Ref ref) {
  return CancelOrder(ref.watch(orderRepositoryProvider));
}

@riverpod
class OrderController extends _$OrderController {
  @override
  OrderState build() {
    return const OrderState.initial();
  }

  Future<void> fetchOrders({String role = 'buyer', String? status}) async {
    state = const OrderState.loading();
    final useCase = ref.read(getOrdersUsecaseProvider);
    final result = await useCase.call(role: role, status: status);

    result.fold(
      (failure) => state = OrderState.error(failure.message),
      (orders) => state = OrderState.data(orders),
    );
  }

  Future<void> createOrder(Map<String, dynamic> payload) async {
    state = const OrderState.submitting();
    final useCase = ref.read(createOrderUsecaseProvider);
    final result = await useCase.call(payload: payload);

    result.fold(
      (failure) => state = OrderState.error(failure.message),
      (data) => state = OrderState.orderCreated(data),
    );
  }
}

@riverpod
Future<List<Order>> orders(Ref ref, Map<String, dynamic> params) async {
  final useCase = ref.read(getOrdersUsecaseProvider);
  final role = params['role'] as String? ?? 'buyer';
  final result = await useCase.call(role: role);
  return result.fold((failure) => throw Exception(failure.message), (orders) => orders);
}

@riverpod
Future<Order> orderDetail(Ref ref, String orderId) async {
  final useCase = ref.read(getOrderDetailUsecaseProvider);
  final result = await useCase.call(orderId: orderId);
  return result.fold((failure) => throw Exception(failure.message), (order) => order);
}
