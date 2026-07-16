import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/paginated_response.dart';
import '../entities/sourcing_request.dart';
import '../repositories/sourcing_repository.dart';

class GetMySourcingRequests {
  final SourcingRepository repository;

  GetMySourcingRequests(this.repository);

  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getMySourcingRequests(
      page: page,
      limit: limit,
    );
  }
}
