import '../../core/error/failures.dart';
import '../../features/users/domain/repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
