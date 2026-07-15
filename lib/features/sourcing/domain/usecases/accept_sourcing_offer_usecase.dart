import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/sourcing_repository.dart';

class AcceptSourcingOfferUseCase {
  final SourcingRepository repository;

  AcceptSourcingOfferUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String offerId) {
    return repository.acceptSourcingOffer(offerId);
  }
}
