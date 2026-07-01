import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../features/users/domain/entities/address.dart';
import '../../features/users/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await repository.getAddresses();
  }
}
