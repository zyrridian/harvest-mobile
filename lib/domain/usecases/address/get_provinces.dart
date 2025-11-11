import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class GetProvinces {
  final AddressRepository repository;

  GetProvinces(this.repository);

  Future<Either<Failure, List<Province>>> call() async {
    return await repository.getProvinces();
  }
}
