import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final response = await localDataSource.getAddresses();
      final List<dynamic> addressesData = response['data']['addresses'];
      final addresses = addressesData
          .map((json) => AddressModel.fromJson(json).toEntity())
          .toList();
      return Right(addresses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress({
    required String label,
    required String recipientName,
    required String phone,
    required String fullAddress,
    required String province,
    required int provinceId,
    required String city,
    required int cityId,
    required String district,
    required int districtId,
    String? subdistrict,
    required String postalCode,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await localDataSource.addAddress({
        'label': label,
        'recipientName': recipientName,
        'phone': phone,
        'fullAddress': fullAddress,
        'province': province,
        'provinceId': provinceId,
        'city': city,
        'cityId': cityId,
        'district': district,
        'districtId': districtId,
        'subdistrict': subdistrict,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      });
      final address = AddressModel.fromJson(response['data']).toEntity();
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress({
    required String addressId,
    required String label,
    required String recipientName,
    required String phone,
    required String fullAddress,
    required String province,
    required int provinceId,
    required String city,
    required int cityId,
    required String district,
    required int districtId,
    String? subdistrict,
    required String postalCode,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await localDataSource.updateAddress(addressId, {
        'label': label,
        'recipientName': recipientName,
        'phone': phone,
        'fullAddress': fullAddress,
        'province': province,
        'provinceId': provinceId,
        'city': city,
        'cityId': cityId,
        'district': district,
        'districtId': districtId,
        'subdistrict': subdistrict,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      });
      final address = AddressModel.fromJson(response['data']).toEntity();
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await localDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> setPrimaryAddress(String addressId) async {
    try {
      final response = await localDataSource.setPrimaryAddress(addressId);
      final address = AddressModel.fromJson(response['data']).toEntity();
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
