import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class UpdateAddress {
  final AddressRepository repository;

  UpdateAddress(this.repository);

  Future<Either<Failure, Address>> call(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    return await repository.updateAddress(addressId, addressData);
  }
}
