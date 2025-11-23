import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/address.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();

  Future<Either<Failure, Address>> addAddress(Map<String, dynamic> addressData);

  Future<Either<Failure, Address>> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  );

  Future<Either<Failure, void>> deleteAddress(String addressId);

  Future<Either<Failure, Address>> setPrimaryAddress(String addressId);

  Future<Either<Failure, List<Province>>> getProvinces();

  Future<Either<Failure, List<City>>> getCities(int provinceId);

  Future<Either<Failure, List<District>>> getDistricts(int cityId);

  Future<Either<Failure, GeocodeResult>> geocode(
    double latitude,
    double longitude,
  );

  Future<Either<Failure, List<ReverseGeocodeResult>>> reverseGeocode(
    String address,
  );
}
