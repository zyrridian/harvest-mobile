import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data/models/paginated_response_model.dart';
import '../models/sourcing_request_model.dart';
import '../models/sourcing_offer_model.dart';

abstract class SourcingRemoteDataSource {
  Future<PaginatedResponseModel<SourcingRequestModel>> getOpenSourcingRequests({
    int page = 1,
    int limit = 10,
  });

  Future<SourcingRequestModel> createSourcingRequest({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  });

  Future<PaginatedResponseModel<SourcingRequestModel>> getMySourcingRequests({
    int page = 1,
    int limit = 10,
  });

  Future<List<SourcingOfferModel>> getSourcingOffers(String requestId);

  Future<SourcingOfferModel> submitSourcingOffer({
    required String requestId,
    required double price,
    String? notes,
  });
}

class SourcingRemoteDataSourceImpl implements SourcingRemoteDataSource {
  final Dio dio;

  SourcingRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedResponseModel<SourcingRequestModel>> getOpenSourcingRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '/sourcing-requests',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => SourcingRequestModel.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw ServerException('Failed to fetch open sourcing requests');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException('Unauthorized', statusCode: e.response?.statusCode);
      }
      throw ServerException(
          e.response?.data?['message'] ?? e.message,
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SourcingRequestModel> createSourcingRequest({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  }) async {
    try {
      final response = await dio.post(
        '/sourcing-requests',
        data: {
          'title': title,
          'description': description,
          if (budget != null) 'budget': budget,
          if (requiredBy != null) 'required_by': requiredBy.toIso8601String(),
        },
      );
      if (response.statusCode == 201) {
        return SourcingRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to create sourcing request');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? e.message,
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaginatedResponseModel<SourcingRequestModel>> getMySourcingRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '/sourcing-requests/me',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        return PaginatedResponseModel.fromJson(
          response.data,
          (json) => SourcingRequestModel.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw ServerException('Failed to fetch my sourcing requests');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? e.message,
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SourcingOfferModel>> getSourcingOffers(String requestId) async {
    try {
      final response = await dio.get(
        '/sourcing-requests/$requestId/offers',
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => SourcingOfferModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch offers');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? e.message,
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SourcingOfferModel> submitSourcingOffer({
    required String requestId,
    required double price,
    String? notes,
  }) async {
    try {
      final response = await dio.post(
        '/sourcing-requests/$requestId/offers',
        data: {
          'price': price,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      if (response.statusCode == 201) {
        return SourcingOfferModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to submit offer');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? e.message,
          statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
