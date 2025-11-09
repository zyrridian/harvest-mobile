import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/farmer.dart';
import '../../repositories/farmer_repository.dart';

class GetFarmerById {
  final FarmerRepository repository;

  GetFarmerById(this.repository);

  Future<Either<Failure, Farmer>> call(String id) async {
    return await repository.getFarmerById(id);
  }
}
