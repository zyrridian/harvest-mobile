import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class SetPrimaryAddressUseCase {
  final AddressRepository repository;

  SetPrimaryAddressUseCase(this.repository);

  Future<Either<Failure, Address>> call(String addressId) async {
    return await repository.setPrimaryAddress(addressId);
  }
}
