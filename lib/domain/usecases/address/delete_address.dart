import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/address_repository.dart';

class DeleteAddress {
  final AddressRepository repository;

  DeleteAddress(this.repository);

  Future<Either<Failure, void>> call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
