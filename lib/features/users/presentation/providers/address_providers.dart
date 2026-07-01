import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address.dart';
import '../../../../domain/usecases/delete_address_usecase.dart';
import '../../../../domain/usecases/get_addresses_usecase.dart';
import '../../../../domain/usecases/set_primary_address_usecase.dart';
import '../../../../domain/usecases/add_address_usecase.dart';
import '../../../../domain/usecases/update_address_usecase.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../data/datasources/local/address_local_datasource.dart';

// Data Source Provider
final addressLocalDataSourceProvider = Provider((ref) {
  return AddressLocalDataSource();
});

// Repository Provider
final addressRepositoryProvider = Provider((ref) {
  return AddressRepositoryImpl(ref.watch(addressLocalDataSourceProvider));
});

// Use Case Providers
final getAddressesUseCaseProvider = Provider((ref) {
  return GetAddressesUseCase(ref.watch(addressRepositoryProvider));
});

final addAddressUseCaseProvider = Provider((ref) {
  return AddAddressUseCase(ref.watch(addressRepositoryProvider));
});

final updateAddressUseCaseProvider = Provider((ref) {
  return UpdateAddressUseCase(ref.watch(addressRepositoryProvider));
});

final setPrimaryAddressUseCaseProvider = Provider((ref) {
  return SetPrimaryAddressUseCase(ref.watch(addressRepositoryProvider));
});

final deleteAddressUseCaseProvider = Provider((ref) {
  return DeleteAddressUseCase(ref.watch(addressRepositoryProvider));
});

// State Provider
final addressesProvider = FutureProvider<List<Address>>((ref) async {
  final useCase = ref.watch(getAddressesUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (addresses) => addresses,
  );
});
