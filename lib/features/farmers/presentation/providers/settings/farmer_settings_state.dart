import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';

import '../../../domain/entities/farmer_profile.dart';

part 'farmer_settings_state.freezed.dart';

@freezed
class FarmerSettingsState with _$FarmerSettingsState {
  const factory FarmerSettingsState.loading() = _Loading;
  const factory FarmerSettingsState.data({
    required FarmerProfile profile,
    required DeliverySettings deliverySettings,
  }) = _Data;
  const factory FarmerSettingsState.error(String message) = _Error;
}
