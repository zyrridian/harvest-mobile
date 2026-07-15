import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/paginated_response.dart';
import '../entities/sourcing_request.dart';
import '../repositories/sourcing_repository.dart';

class GetOpenSourcingRequests {
  final SourcingRepository repository;

  GetOpenSourcingRequests(this.repository);

  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getOpenSourcingRequests(
      page: page,
      limit: limit,
    );
  }
}
