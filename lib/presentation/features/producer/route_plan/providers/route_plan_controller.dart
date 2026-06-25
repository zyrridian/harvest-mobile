import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/data/datasources/local/route_plan_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/route_plan_remote_datasource.dart';
import 'package:harvest_app/data/repositories/route_plan_repository_impl.dart';
import 'package:harvest_app/domain/repositories/route_plan_repository.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/create_route_plan_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/get_route_plan_detail_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/get_route_plans_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'route_plan_state.dart';
import 'package:intl/intl.dart';

part 'route_plan_controller.g.dart';

@riverpod
RoutePlanRepository routePlanRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));

  return RoutePlanRepositoryImpl(
    remoteDataSource: RoutePlanRemoteDataSourceImpl(dio),
    localDataSource: RoutePlanLocalDataSourceImpl(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    ),
  );
}

@riverpod
GetRoutePlansUseCase getRoutePlansUseCase(Ref ref) {
  return GetRoutePlansUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
GetRoutePlanDetailUseCase getRoutePlanDetailUseCase(Ref ref) {
  return GetRoutePlanDetailUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
CreateRoutePlanUseCase createRoutePlanUseCase(Ref ref) {
  return CreateRoutePlanUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
class RoutePlanController extends _$RoutePlanController {
  late String _currentDate;

  @override
  RoutePlanState build() {
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fetchRoutePlans(_currentDate);
    return const RoutePlanState.loading();
  }

  Future<void> _fetchRoutePlans(String date) async {
    state = const RoutePlanState.loading();
    final result = await ref.read(getRoutePlansUseCaseProvider).call(date);

    result.fold(
      (failure) => state = RoutePlanState.error(failure.message),
      (data) => state = RoutePlanState.data(data),
    );
  }

  Future<void> setDate(DateTime date) async {
    _currentDate = DateFormat('yyyy-MM-dd').format(date);
    await _fetchRoutePlans(_currentDate);
  }
  
  String get currentDate => _currentDate;

  Future<void> refresh() async {
    await _fetchRoutePlans(_currentDate);
  }
  
  Future<bool> createRoutePlan(List<String> orderIds) async {
    state = const RoutePlanState.loading();
    final result = await ref.read(createRoutePlanUseCaseProvider).call(
      date: _currentDate,
      orderIds: orderIds,
    );

    return result.fold(
      (failure) {
        state = RoutePlanState.error(failure.message);
        return false;
      },
      (data) {
        // Refresh the list
        _fetchRoutePlans(_currentDate);
        return true;
      },
    );
  }
}
