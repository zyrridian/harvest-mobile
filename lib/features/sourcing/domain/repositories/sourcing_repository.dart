import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/paginated_response.dart';
import '../entities/sourcing_request.dart';
import '../entities/sourcing_offer.dart';

abstract class SourcingRepository {
  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> getOpenSourcingRequests({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, SourcingRequest>> createSourcingRequest({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  });

  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> getMySourcingRequests({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<SourcingOffer>>> getSourcingOffers(String requestId);

  Future<Either<Failure, SourcingOffer>> submitSourcingOffer({
    required String requestId,
    required double price,
    String? notes,
  });
}
