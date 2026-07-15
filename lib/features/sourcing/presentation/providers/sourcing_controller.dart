import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/domain/entities/paginated_response.dart';

import '../../domain/entities/sourcing_request.dart';
import '../../domain/entities/sourcing_offer.dart';
import '../../domain/repositories/sourcing_repository.dart';
import '../../data/datasources/sourcing_remote_datasource.dart';
import '../../data/repositories/sourcing_repository_impl.dart';

import '../../domain/usecases/get_open_sourcing_requests.dart';
import '../../domain/usecases/create_sourcing_request.dart';
import '../../domain/usecases/get_my_sourcing_requests.dart';
import '../../domain/usecases/get_sourcing_offers.dart';
import '../../domain/usecases/submit_sourcing_offer.dart';
import '../../domain/usecases/get_my_sourcing_offers_usecase.dart';
import '../../domain/usecases/accept_sourcing_offer_usecase.dart';
import '../../domain/usecases/cancel_sourcing_request_usecase.dart';

// --- Dependency Injection ---

final sourcingRemoteDataSourceProvider = Provider<SourcingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return SourcingRemoteDataSourceImpl(dio);
});

final sourcingRepositoryProvider = Provider<SourcingRepository>((ref) {
  final remoteDataSource = ref.watch(sourcingRemoteDataSourceProvider);
  return SourcingRepositoryImpl(remoteDataSource);
});

// --- Use Case Providers ---

final getOpenSourcingRequestsProvider = Provider<GetOpenSourcingRequests>((ref) {
  return GetOpenSourcingRequests(ref.watch(sourcingRepositoryProvider));
});

final createSourcingRequestProvider = Provider<CreateSourcingRequest>((ref) {
  return CreateSourcingRequest(ref.watch(sourcingRepositoryProvider));
});

final getMySourcingRequestsProvider = Provider<GetMySourcingRequests>((ref) {
  return GetMySourcingRequests(ref.watch(sourcingRepositoryProvider));
});

final getSourcingOffersProvider = Provider<GetSourcingOffers>((ref) {
  return GetSourcingOffers(ref.watch(sourcingRepositoryProvider));
});

final submitSourcingOfferProvider = Provider<SubmitSourcingOffer>((ref) {
  return SubmitSourcingOffer(ref.watch(sourcingRepositoryProvider));
});

final getMySourcingOffersProvider = Provider<GetMySourcingOffersUseCase>((ref) {
  return GetMySourcingOffersUseCase(ref.watch(sourcingRepositoryProvider));
});

final acceptSourcingOfferProvider = Provider<AcceptSourcingOfferUseCase>((ref) {
  return AcceptSourcingOfferUseCase(ref.watch(sourcingRepositoryProvider));
});

final cancelSourcingRequestProvider = Provider<CancelSourcingRequestUseCase>((ref) {
  return CancelSourcingRequestUseCase(ref.watch(sourcingRepositoryProvider));
});

// --- State Providers ---

final openSourcingRequestsFutureProvider = FutureProvider.family<PaginatedResponse<SourcingRequest>, int>((ref, page) async {
  final usecase = ref.watch(getOpenSourcingRequestsProvider);
  final result = await usecase(page: page);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

final mySourcingRequestsFutureProvider = FutureProvider.family<PaginatedResponse<SourcingRequest>, int>((ref, page) async {
  final usecase = ref.watch(getMySourcingRequestsProvider);
  final result = await usecase(page: page);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

final sourcingOffersFutureProvider = FutureProvider.family<List<SourcingOffer>, String>((ref, requestId) async {
  final usecase = ref.watch(getSourcingOffersProvider);
  final result = await usecase(requestId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

final mySourcingOffersFutureProvider = FutureProvider.family<PaginatedResponse<SourcingOffer>, int>((ref, page) async {
  final usecase = ref.watch(getMySourcingOffersProvider);
  final result = await usecase(page: page);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// --- Action Providers ---

class SourcingActionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  SourcingActionController(this.ref) : super(const AsyncData(null));

  Future<void> createRequest({
    required String title,
    required String description,
    double? budget,
    DateTime? requiredBy,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(createSourcingRequestProvider);
    final result = await usecase(
      title: title,
      description: description,
      budget: budget,
      requiredBy: requiredBy,
    );
    
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (data) {
        state = const AsyncData(null);
        // Invalidate to refresh my requests
        ref.invalidate(mySourcingRequestsFutureProvider);
      },
    );
  }

  Future<void> submitOffer({
    required String requestId,
    required double price,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(submitSourcingOfferProvider);
    final result = await usecase(
      requestId: requestId,
      price: price,
      notes: notes,
    );
    
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (data) {
        state = const AsyncData(null);
        // Invalidate to refresh offers
        ref.invalidate(sourcingOffersFutureProvider);
        ref.invalidate(openSourcingRequestsFutureProvider);
      },
    );
  }

  Future<String?> acceptOffer(String offerId) async {
    state = const AsyncLoading();
    final usecase = ref.read(acceptSourcingOfferProvider);
    final result = await usecase(offerId);
    
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
      (data) {
        state = const AsyncData(null);
        ref.invalidate(mySourcingRequestsFutureProvider);
        ref.invalidate(sourcingOffersFutureProvider);
        return data['conversation_id'] as String?;
      },
    );
  }

  Future<void> cancelRequest(String requestId) async {
    state = const AsyncLoading();
    final usecase = ref.read(cancelSourcingRequestProvider);
    final result = await usecase(requestId);
    
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (data) {
        state = const AsyncData(null);
        ref.invalidate(mySourcingRequestsFutureProvider);
        ref.invalidate(openSourcingRequestsFutureProvider);
      },
    );
  }
}

final sourcingActionControllerProvider = StateNotifierProvider<SourcingActionController, AsyncValue<void>>((ref) {
  return SourcingActionController(ref);
});
