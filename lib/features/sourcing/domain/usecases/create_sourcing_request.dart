import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/sourcing_request.dart';
import '../repositories/sourcing_repository.dart';

class CreateSourcingRequest {
  final SourcingRepository repository;

  CreateSourcingRequest(this.repository);

  Future<Either<Failure, SourcingRequest>> call({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  }) async {
    return await repository.createSourcingRequest(
      title: title,
      description: description,
      budget: budget,
      requiredBy: requiredBy,
    );
  }
}
