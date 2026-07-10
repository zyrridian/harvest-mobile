import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/domain/entities/explore.dart';
import 'package:harvest_app/domain/repositories/explore_repository.dart';
import 'package:harvest_app/domain/usecases/explore/get_explore_data_usecase.dart';
import 'package:harvest_app/data/repositories/explore_repository_impl.dart';
import 'package:harvest_app/features/explore/data/datasources/remote/explore_remote_datasource.dart';

part 'explore_controller.freezed.dart';
part 'explore_controller.g.dart';

@freezed
class ExploreState with _$ExploreState {
  const factory ExploreState.initial() = _Initial;
  const factory ExploreState.loading() = _Loading;
  const factory ExploreState.loaded(Explore explore) = _Loaded;
  const factory ExploreState.error(String message) = _Error;
}

@riverpod
ExploreRepository exploreRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ExploreRepositoryImpl(
    remoteDataSource: ExploreRemoteDataSourceImpl(dio),
  );
}

@riverpod
GetExploreDataUseCase getExploreDataUseCase(Ref ref) {
  return GetExploreDataUseCase(ref.watch(exploreRepositoryProvider));
}

@riverpod
class ExploreController extends _$ExploreController {
  @override
  ExploreState build() {
    _fetchExploreData();
    return const ExploreState.loading();
  }

  Future<void> _fetchExploreData() async {
    state = const ExploreState.loading();
    final result = await ref.read(getExploreDataUseCaseProvider).execute();

    result.fold(
      (failure) => state = ExploreState.error(failure.message),
      (data) => state = ExploreState.loaded(data),
    );
  }

  Future<void> refresh() async {
    await _fetchExploreData();
  }
}
