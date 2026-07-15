import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/farmer_detail.dart';
import 'package:harvest_app/domain/repositories/farmer_repository.dart';

class GetFarmerDetailById {
  final FarmerRepository repository;

  GetFarmerDetailById(this.repository);

  Future<Either<Failure, FarmerDetail>> call(String id) async {
    return await repository.getFarmerDetailById(id);
  }
}
