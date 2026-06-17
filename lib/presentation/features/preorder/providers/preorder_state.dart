import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/preorder.dart';

part 'preorder_state.freezed.dart';

class PreOrderData {
  final int activeHarvests;
  final int yourReservations;
  final String avgSavings;
  final List<PreOrderHarvest> availableHarvests;
  final List<PreOrderReservation> activeReservations;
  final int selectedTabIndex;

  PreOrderData({
    required this.activeHarvests,
    required this.yourReservations,
    required this.avgSavings,
    required this.availableHarvests,
    required this.activeReservations,
    this.selectedTabIndex = 0,
  });

  factory PreOrderData.fromResponseEntity(
    PreOrderResponseEntity entity, {
    int selectedTabIndex = 0,
  }) {
    return PreOrderData(
      activeHarvests: entity.activeHarvests,
      yourReservations: entity.yourReservations,
      avgSavings: entity.avgSavings,
      availableHarvests: entity.availableHarvests,
      activeReservations: entity.activeReservations,
      selectedTabIndex: selectedTabIndex,
    );
  }

  PreOrderData copyWith({
    int? activeHarvests,
    int? yourReservations,
    String? avgSavings,
    List<PreOrderHarvest>? availableHarvests,
    List<PreOrderReservation>? activeReservations,
    int? selectedTabIndex,
  }) {
    return PreOrderData(
      activeHarvests: activeHarvests ?? this.activeHarvests,
      yourReservations: yourReservations ?? this.yourReservations,
      avgSavings: avgSavings ?? this.avgSavings,
      availableHarvests: availableHarvests ?? this.availableHarvests,
      activeReservations: activeReservations ?? this.activeReservations,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

@freezed
class PreOrderState with _$PreOrderState {
  const factory PreOrderState.initial() = _Initial;
  const factory PreOrderState.loading() = _Loading;
  const factory PreOrderState.data(PreOrderData data) = _Data;
  const factory PreOrderState.error(String message) = _Error;
}
