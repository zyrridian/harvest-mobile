import 'package:dartz/dartz.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import '../../../../core/error/failure.dart';
import '../repositories/farmer_repository.dart';

class GetFarmerById {
  final FarmerRepository repository;

  GetFarmerById(this.repository);

  Future<Either<Failure, Farmer>> call(String id) async {
    return await repository.getFarmerById(id);
  }
}
