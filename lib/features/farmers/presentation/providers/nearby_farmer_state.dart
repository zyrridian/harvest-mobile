import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../domain/entities/nearby_farmer.dart';

part 'nearby_farmer_state.freezed.dart';

@freezed
class NearbyFarmerState with _$NearbyFarmerState {
  const factory NearbyFarmerState.initial() = _Initial;
  const factory NearbyFarmerState.loading() = _Loading;
  const factory NearbyFarmerState.data({
    required List<NearbyFarmerData> farmers,
    @Default('') String searchQuery,
    @Default(false) bool isOrganicFilter,
    @Default(false) bool isOpenNowFilter,
  }) = _Data;
  const factory NearbyFarmerState.error(String message) = _Error;
}
