import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/sourcing_offer.dart';
import '../repositories/sourcing_repository.dart';

class SubmitSourcingOffer {
  final SourcingRepository repository;

  SubmitSourcingOffer(this.repository);

  Future<Either<Failure, SourcingOffer>> call({
    required String requestId,
    required double price,
    String? notes,
  }) async {
    return await repository.submitSourcingOffer(
      requestId: requestId,
      price: price,
      notes: notes,
    );
  }
}
