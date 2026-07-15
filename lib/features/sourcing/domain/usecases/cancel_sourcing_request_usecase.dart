import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/sourcing_repository.dart';

class CancelSourcingRequestUseCase {
  final SourcingRepository repository;

  CancelSourcingRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) {
    return repository.cancelSourcingRequest(requestId);
  }
}
