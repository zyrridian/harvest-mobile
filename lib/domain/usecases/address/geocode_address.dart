import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class GeocodeAddress {
  final AddressRepository repository;

  GeocodeAddress(this.repository);

  Future<Either<Failure, GeocodeResult>> call(
    double latitude,
    double longitude,
  ) async {
    return await repository.geocode(latitude, longitude);
  }
}
