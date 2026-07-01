import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/address.dart';

part 'address_state.freezed.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState.initial() = AddressInitial;
  const factory AddressState.loading() = AddressLoading;
  const factory AddressState.data(List<Address> data) = AddressData;
  const factory AddressState.error(String message) = AddressError;
}
