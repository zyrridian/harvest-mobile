import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/data/datasources/remote/order_remote_datasource.dart';
import 'package:harvest_app/data/repositories/order_repository_impl.dart';
import 'package:harvest_app/domain/usecases/order/get_orders.dart';
import 'package:harvest_app/domain/usecases/order/get_order_detail.dart';
import 'package:harvest_app/domain/usecases/order/create_order.dart';
import 'package:harvest_app/domain/usecases/order/cancel_order.dart';

final orderRemoteDataSourceProvider =
    Provider((ref) => OrderRemoteDataSource());
final orderRepositoryProvider = Provider((ref) =>
    OrderRepositoryImpl(remote: ref.read(orderRemoteDataSourceProvider)));

final getOrdersUsecaseProvider =
    Provider((ref) => GetOrders(ref.read(orderRepositoryProvider)));
final getOrderDetailUsecaseProvider =
    Provider((ref) => GetOrderDetail(ref.read(orderRepositoryProvider)));
final createOrderUsecaseProvider =
    Provider((ref) => CreateOrder(ref.read(orderRepositoryProvider)));
final cancelOrderUsecaseProvider =
    Provider((ref) => CancelOrder(ref.read(orderRepositoryProvider)));

final ordersProvider =
    FutureProvider.family((ref, Map<String, dynamic> params) async {
  final uc = ref.read(getOrdersUsecaseProvider);
  final role = params['role'] as String? ?? 'buyer';
  final res = await uc.call(role: role);
  return res.fold((l) => throw Exception(l.message), (r) => r);
});

final orderDetailProvider = FutureProvider.family((ref, String orderId) async {
  final uc = ref.read(getOrderDetailUsecaseProvider);
  final res = await uc.call(orderId: orderId);
  return res.fold((l) => throw Exception(l.message), (r) => r);
});
