import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class ReverseGeocodeAddress {
  final AddressRepository repository;

  ReverseGeocodeAddress(this.repository);

  Future<Either<Failure, List<ReverseGeocodeResult>>> call(
    String address,
  ) async {
    return await repository.reverseGeocode(address);
  }
}
