import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class GetCities {
  final AddressRepository repository;

  GetCities(this.repository);

  Future<Either<Failure, List<City>>> call(int provinceId) async {
    return await repository.getCities(provinceId);
  }
}
