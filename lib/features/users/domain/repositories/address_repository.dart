import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failures.dart';
import 'package:harvest_app/features/users/domain/entities/address.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();

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
  });

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
  });

  Future<Either<Failure, void>> deleteAddress(String addressId);

  Future<Either<Failure, void>> setPrimaryAddress(String addressId);
}
