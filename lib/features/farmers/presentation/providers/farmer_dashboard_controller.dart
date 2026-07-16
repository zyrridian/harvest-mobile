import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/farmers/data/datasources/remote/producer_remote_datasource.dart';
import 'package:harvest_app/data/repositories/producer_repository_impl.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';
import 'package:harvest_app/domain/usecases/producer/get_farmer_stats_usecase.dart';
import 'farmer_dashboard_state.dart';

part 'farmer_dashboard_controller.g.dart';

@riverpod
ProducerRepository producerRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ProducerRepositoryImpl(
    remoteDataSource: ProducerRemoteDataSourceImpl(dio),
  );
}

@riverpod
GetFarmerStatsUseCase getFarmerStatsUseCase(Ref ref) {
  return GetFarmerStatsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class FarmerDashboardController extends _$FarmerDashboardController {
  @override
  FarmerDashboardState build() {
    _fetchStats();
    return const FarmerDashboardState.loading();
  }

  Future<void> _fetchStats() async {
    state = const FarmerDashboardState.loading();
    final result = await ref.read(getFarmerStatsUseCaseProvider).call();

    result.fold(
      (failure) => state = FarmerDashboardState.error(failure.message),
      (data) => state = FarmerDashboardState.data(data),
    );
  }

  Future<void> refresh() async {
    await _fetchStats();
  }
}
