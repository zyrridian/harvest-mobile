import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/farmer_order.dart';

part 'farmer_orders_state.freezed.dart';

@freezed
class FarmerOrdersState with _$FarmerOrdersState {
  const factory FarmerOrdersState.loading() = _Loading;
  const factory FarmerOrdersState.data(List<FarmerOrder> orders) = _Data;
  const factory FarmerOrdersState.error(String message) = _Error;
}
