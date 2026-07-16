import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/harvest_schedule_repository.dart';

class PayDepositUseCase {
  final HarvestScheduleRepository repository;

  PayDepositUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String harvestId,
  }) async {
    return await repository.payDeposit(harvestId: harvestId);
  }
}
