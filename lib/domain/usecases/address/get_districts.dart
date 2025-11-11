import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/address.dart';
import '../../repositories/address_repository.dart';

class GetDistricts {
  final AddressRepository repository;

  GetDistricts(this.repository);

  Future<Either<Failure, List<District>>> call(int cityId) async {
    return await repository.getDistricts(cityId);
  }
}
