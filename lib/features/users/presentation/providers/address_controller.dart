import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/users/domain/usecases/add_address_usecase.dart';
import 'package:harvest_app/features/users/domain/usecases/delete_address_usecase.dart';
import 'package:harvest_app/features/users/domain/usecases/get_addresses_usecase.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/features/users/data/datasources/remote/address_remote_datasource.dart';
import 'package:harvest_app/features/users/data/datasources/local/address_local_datasource.dart';
import 'package:harvest_app/features/users/data/repositories/address_repository_impl.dart';
import 'package:harvest_app/features/users/domain/repositories/address_repository.dart';
import 'package:harvest_app/features/users/domain/usecases/get_addresses_usecase.dart';
import 'package:harvest_app/features/users/domain/usecases/set_primary_address_usecase.dart';
import 'package:harvest_app/features/users/domain/usecases/update_address_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'address_state.dart';

part 'address_controller.g.dart';

@riverpod
AddressRepository addressRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  
  return AddressRepositoryImpl(
    remoteDataSource: AddressRemoteDataSourceImpl(dio),
    localDataSource: AddressLocalDataSourceImpl(sharedPreferences),
  );
}

@riverpod
GetAddressesUseCase getAddressesUseCase(Ref ref) {
  return GetAddressesUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
AddAddressUseCase addAddressUseCase(Ref ref) {
  return AddAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
UpdateAddressUseCase updateAddressUseCase(Ref ref) {
  return UpdateAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
SetPrimaryAddressUseCase setPrimaryAddressUseCase(Ref ref) {
  return SetPrimaryAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
DeleteAddressUseCase deleteAddressUseCase(Ref ref) {
  return DeleteAddressUseCase(ref.watch(addressRepositoryProvider));
}

@riverpod
class AddressController extends _$AddressController {
  @override
  AddressState build() {
    _fetchAddresses();
    return const AddressState.loading();
  }

  Future<void> _fetchAddresses() async {
    state = const AddressState.loading();
    final result = await ref.read(getAddressesUseCaseProvider).call();

    result.fold(
      (failure) => state = AddressState.error(failure.message),
      (data) => state = AddressState.data(data),
    );
  }

  Future<void> refresh() async {
    await _fetchAddresses();
  }

  Future<void> setPrimaryAddress(String addressId) async {
    final result = await ref.read(setPrimaryAddressUseCaseProvider).call(addressId);
    result.fold(
      (failure) {
        state = AddressState.error(failure.message);
      },
      (_) {
        _fetchAddresses();
      },
    );
  }

  Future<void> deleteAddress(String addressId) async {
    final result = await ref.read(deleteAddressUseCaseProvider).call(addressId);
    result.fold(
      (failure) {
        state = AddressState.error(failure.message);
      },
      (_) {
        _fetchAddresses();
      },
    );
  }
}
