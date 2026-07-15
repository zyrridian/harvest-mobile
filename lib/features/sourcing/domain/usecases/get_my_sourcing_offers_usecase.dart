import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/paginated_response.dart';
import '../entities/sourcing_offer.dart';
import '../repositories/sourcing_repository.dart';

class GetMySourcingOffersUseCase {
  final SourcingRepository repository;

  GetMySourcingOffersUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<SourcingOffer>>> call({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getMySourcingOffers(page: page, limit: limit);
  }
}
