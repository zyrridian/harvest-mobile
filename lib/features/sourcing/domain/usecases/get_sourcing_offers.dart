import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/sourcing_offer.dart';
import '../repositories/sourcing_repository.dart';

class GetSourcingOffers {
  final SourcingRepository repository;

  GetSourcingOffers(this.repository);

  Future<Either<Failure, List<SourcingOffer>>> call(String requestId) async {
    return await repository.getSourcingOffers(requestId);
  }
}
