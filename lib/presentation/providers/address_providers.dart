import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/address_remote_datasource.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/address/get_addresses.dart';
import '../../domain/usecases/address/add_address.dart';
import '../../domain/usecases/address/update_address.dart';
import '../../domain/usecases/address/delete_address.dart';
import '../../domain/usecases/address/set_primary_address.dart';
import '../../domain/usecases/address/get_provinces.dart';
import '../../domain/usecases/address/get_cities.dart';
import '../../domain/usecases/address/get_districts.dart';
import '../../domain/usecases/address/geocode_address.dart';
import '../../domain/usecases/address/reverse_geocode_address.dart';

// Data Source Provider
final addressDataSourceProvider = Provider<AddressRemoteDataSource>((ref) {
  return AddressRemoteDataSourceImpl();
});

// Repository Provider
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dataSource = ref.watch(addressDataSourceProvider);
  return AddressRepositoryImpl(remoteDataSource: dataSource);
});

// Use Case Providers
final getAddressesUseCaseProvider = Provider<GetAddresses>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return GetAddresses(repository);
});

final addAddressUseCaseProvider = Provider<AddAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return AddAddress(repository);
});

final updateAddressUseCaseProvider = Provider<UpdateAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return UpdateAddress(repository);
});

final deleteAddressUseCaseProvider = Provider<DeleteAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return DeleteAddress(repository);
});

final setPrimaryAddressUseCaseProvider = Provider<SetPrimaryAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return SetPrimaryAddress(repository);
});

final getProvincesUseCaseProvider = Provider<GetProvinces>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return GetProvinces(repository);
});

final getCitiesUseCaseProvider = Provider<GetCities>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return GetCities(repository);
});

final getDistrictsUseCaseProvider = Provider<GetDistricts>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return GetDistricts(repository);
});

final geocodeAddressUseCaseProvider = Provider<GeocodeAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return GeocodeAddress(repository);
});

final reverseGeocodeAddressUseCaseProvider =
    Provider<ReverseGeocodeAddress>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return ReverseGeocodeAddress(repository);
});

// Addresses List Provider
final addressesProvider =
    FutureProvider.autoDispose<List<Address>>((ref) async {
  final useCase = ref.watch(getAddressesUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (addresses) => addresses,
  );
});

// Provinces Provider
final provincesProvider =
    FutureProvider.autoDispose<List<Province>>((ref) async {
  final useCase = ref.watch(getProvincesUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (provinces) => provinces,
  );
});

// Cities Provider (family)
final citiesProvider =
    FutureProvider.autoDispose.family<List<City>, int>((ref, provinceId) async {
  final useCase = ref.watch(getCitiesUseCaseProvider);
  final result = await useCase(provinceId);

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (cities) => cities,
  );
});

// Districts Provider (family)
final districtsProvider =
    FutureProvider.autoDispose.family<List<District>, int>((ref, cityId) async {
  final useCase = ref.watch(getDistrictsUseCaseProvider);
  final result = await useCase(cityId);

  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (districts) => districts,
  );
});

// Primary Address Provider
final primaryAddressProvider = Provider.autoDispose<Address?>((ref) {
  final addressesAsync = ref.watch(addressesProvider);

  return addressesAsync.maybeWhen(
    data: (addresses) {
      if (addresses.isEmpty) return null;
      try {
        return addresses.firstWhere((address) => address.isPrimary);
      } catch (e) {
        return addresses.first;
      }
    },
    orElse: () => null,
  );
});
