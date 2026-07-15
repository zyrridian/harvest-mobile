import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/farmer.dart';

part 'farmers_state.freezed.dart';

@freezed
class FarmersState with _$FarmersState {
  const factory FarmersState.initial() = _Initial;
  const factory FarmersState.loading() = _Loading;
  const factory FarmersState.loaded(List<Farmer> farmers) = _Loaded;
  const factory FarmersState.error(String message) = _Error;
}

enum FarmerViewMode { list, map }
