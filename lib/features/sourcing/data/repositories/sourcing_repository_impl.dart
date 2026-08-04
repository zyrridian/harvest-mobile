import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/entities/sourcing_request.dart';
import '../../domain/entities/sourcing_offer.dart';
import '../../domain/repositories/sourcing_repository.dart';
import '../datasources/sourcing_remote_datasource.dart';
import '../models/sourcing_request_model.dart';
import '../models/sourcing_offer_model.dart';

class SourcingRepositoryImpl implements SourcingRepository {
  final SourcingRemoteDataSource remoteDataSource;

  SourcingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> getOpenSourcingRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final remoteResponse = await remoteDataSource.getOpenSourcingRequests(
        page: page,
        limit: limit,
      );
      return Right(remoteResponse.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, SourcingRequest>> createSourcingRequest({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  }) async {
    try {
      final remoteModel = await remoteDataSource.createSourcingRequest(
        title: title,
        description: description,
        budget: budget,
        requiredBy: requiredBy,
      );
      return Right(remoteModel.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<SourcingRequest>>> getMySourcingRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final remoteResponse = await remoteDataSource.getMySourcingRequests(
        page: page,
        limit: limit,
      );
      return Right(remoteResponse.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<SourcingOffer>>> getSourcingOffers(String requestId) async {
    try {
      final remoteModels = await remoteDataSource.getSourcingOffers(requestId);
      return Right(remoteModels.map((m) => m.toEntity()).toList());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, SourcingOffer>> submitSourcingOffer({
    required String requestId,
    required double price,
    String? notes,
  }) async {
    try {
      final remoteModel = await remoteDataSource.submitSourcingOffer(
        requestId: requestId,
        price: price,
        notes: notes,
      );
      return Right(remoteModel.toEntity());
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<SourcingOffer>>> getMySourcingOffers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final remoteResponse = await remoteDataSource.getMySourcingOffers(
        page: page,
        limit: limit,
      );
      return Right(remoteResponse.toEntity((model) => model.toEntity()));
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> acceptSourcingOffer(String offerId) async {
    try {
      final result = await remoteDataSource.acceptSourcingOffer(offerId);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> cancelSourcingRequest(String requestId) async {
    try {
      await remoteDataSource.cancelSourcingRequest(requestId);
      return const Right(null);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } else if (e is AuthException) {
        return Left(AuthFailure(e.message, statusCode: e.statusCode));
      } else {
        return Left(UnexpectedFailure('An unexpected error occurred: $e'));
      }
    }
  }
}
