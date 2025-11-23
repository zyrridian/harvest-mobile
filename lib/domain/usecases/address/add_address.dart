import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class AddAddress {
  final AddressRepository repository;

  AddAddress(this.repository);

  Future<Either<Failure, Address>> call(
      Map<String, dynamic> addressData) async {
    return await repository.addAddress(addressData);
  }
}
