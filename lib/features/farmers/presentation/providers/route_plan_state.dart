import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/farmers/domain/entities/route_plan.dart';

part 'route_plan_state.freezed.dart';

@freezed
class RoutePlanState with _$RoutePlanState {
  const factory RoutePlanState.initial() = _Initial;
  const factory RoutePlanState.loading() = _Loading;
  const factory RoutePlanState.data(List<RoutePlan> routes) = _Data;
  const factory RoutePlanState.error(String message) = _Error;
}
