import 'package:dartz/dartz.dart';
import 'package:harvest_app/features/users/domain/entities/address.dart';
import '../../../../core/error/failures.dart';
import '../repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await repository.getAddresses();
  }
}
