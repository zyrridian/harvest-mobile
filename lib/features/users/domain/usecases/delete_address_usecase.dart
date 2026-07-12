import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
