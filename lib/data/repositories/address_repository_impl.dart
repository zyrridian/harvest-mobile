import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/remote/address_remote_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final result = await remoteDataSource.getAddresses();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(
    Map<String, dynamic> addressData,
  ) async {
    try {
      final result = await remoteDataSource.addAddress(addressData);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final result = await remoteDataSource.updateAddress(
        addressId,
        addressData,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> setPrimaryAddress(String addressId) async {
    try {
      final result = await remoteDataSource.setPrimaryAddress(addressId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Province>>> getProvinces() async {
    try {
      final result = await remoteDataSource.getProvinces();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<City>>> getCities(int provinceId) async {
    try {
      final result = await remoteDataSource.getCities(provinceId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<District>>> getDistricts(int cityId) async {
    try {
      final result = await remoteDataSource.getDistricts(cityId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GeocodeResult>> geocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final result = await remoteDataSource.geocode(latitude, longitude);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReverseGeocodeResult>>> reverseGeocode(
    String address,
  ) async {
    try {
      final result = await remoteDataSource.reverseGeocode(address);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
