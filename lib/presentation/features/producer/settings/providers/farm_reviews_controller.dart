import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/usecases/producer/get_farm_reviews_usecase.dart';
import 'package:harvest_app/domain/entities/farm_review.dart';
import '../../dashboard/providers/farmer_dashboard_controller.dart';

part 'farm_reviews_controller.g.dart';

@riverpod
GetFarmReviewsUseCase getFarmReviewsUseCase(Ref ref) {
  return GetFarmReviewsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmReviewsController extends _$FarmReviewsController {
  @override
  AsyncValue<FarmReviewResponse> build() {
    fetchReviews();
    return const AsyncValue.loading();
  }

  Future<void> fetchReviews({int page = 1, int limit = 20}) async {
    state = const AsyncValue.loading();
    final result = await ref.read(getFarmReviewsUseCaseProvider).execute(
          page: page,
          limit: limit,
        );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (response) {
        state = AsyncValue.data(response);
      },
    );
  }

  Future<void> refresh() async {
    await fetchReviews();
  }
}
