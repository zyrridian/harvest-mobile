import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/sales/domain/entities/order.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.submitting() = _Submitting;
  const factory OrderState.data(List<Order> orders) = _Data;
  const factory OrderState.orderCreated(Map<String, dynamic> responseData) = _OrderCreated;
  const factory OrderState.error(String message) = _Error;
}
