import 'package:dartz/dartz.dart';
import 'package:harvest_app/features/users/domain/entities/address.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/local/address_local_datasource.dart';
import '../datasources/remote/address_remote_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final remoteAddresses = await remoteDataSource.getAddresses();
      localDataSource.cacheAddresses(remoteAddresses);
      final addresses =
          remoteAddresses.map((model) => model.toEntity()).toList();
      return Right(addresses);
    } on ServerException {
      try {
        final localAddresses = await localDataSource.getAddresses();
        final addresses =
            localAddresses.map((model) => model.toEntity()).toList();
        return Right(addresses);
      } on CacheException {
        return Left(ServerFailure('Failed to fetch addresses.'));
      }
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress({
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
    bool isPrimary = false,
  }) async {
    try {
      await remoteDataSource.addAddress({
        'label': label,
        'recipient_name': recipientName,
        'phone': phone,
        'full_address': fullAddress,
        'province_id': provinceId,
        'city_id': cityId,
        'district_id': districtId,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
        'is_primary': isPrimary,
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add address'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress({
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
    bool isPrimary = false,
  }) async {
    try {
      await remoteDataSource.updateAddress(addressId, {
        'label': label,
        'recipient_name': recipientName,
        'phone': phone,
        'full_address': fullAddress,
        'province_id': provinceId,
        'city_id': cityId,
        'district_id': districtId,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
        'is_primary': isPrimary,
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update address'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete address'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> setPrimaryAddress(String addressId) async {
    try {
      final response = await remoteDataSource.setPrimaryAddress(addressId);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to set primary address'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
