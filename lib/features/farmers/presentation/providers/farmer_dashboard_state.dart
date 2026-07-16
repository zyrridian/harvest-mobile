import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/farmer_stats.dart';

part 'farmer_dashboard_state.freezed.dart';

@freezed
class FarmerDashboardState with _$FarmerDashboardState {
  const factory FarmerDashboardState.loading() = _Loading;
  const factory FarmerDashboardState.data(FarmerStats stats) = _Data;
  const factory FarmerDashboardState.error(String message) = _Error;
}
