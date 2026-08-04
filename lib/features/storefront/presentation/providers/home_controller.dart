import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/storefront/data/datasources/local/home_local_datasource.dart';
import 'package:harvest_app/features/storefront/data/datasources/remote/home_remote_datasource.dart';
import 'package:harvest_app/features/storefront/data/repositories/home_repository_impl.dart';
import 'package:harvest_app/features/storefront/domain/repositories/home_repository.dart';
import 'package:harvest_app/features/storefront/domain/usecases/get_home_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_state.dart';

part 'home_controller.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));

  return HomeRepositoryImpl(
    remoteDataSource: HomeRemoteDataSourceImpl(dio),
    localDataSource: HomeLocalDataSourceImpl(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    ),
  );
}

@riverpod
GetHomeUseCase getHomeUseCase(Ref ref) {
  return GetHomeUseCase(ref.watch(homeRepositoryProvider));
}

@riverpod
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    _fetchHomeData();
    return const HomeState.loading();
  }

  Future<void> _fetchHomeData() async {
    state = const HomeState.loading();
    final result = await ref.read(getHomeUseCaseProvider).call();

    result.fold(
      (failure) => state = HomeState.error(failure.message),
      (data) => state = HomeState.data(data),
    );
  }

  Future<void> refresh() async {
    await _fetchHomeData();
  }
}
