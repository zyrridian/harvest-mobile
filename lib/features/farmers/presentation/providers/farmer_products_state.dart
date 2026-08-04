import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';

part 'farmer_products_state.freezed.dart';

@freezed
class FarmerProductsState with _$FarmerProductsState {
  const factory FarmerProductsState.loading() = _Loading;
  const factory FarmerProductsState.data(List<FarmerProduct> products) = _Data;
  const factory FarmerProductsState.error(String message) = _Error;
}
