import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/farmers/data/datasources/local/route_plan_local_datasource.dart';
import 'package:harvest_app/features/farmers/data/datasources/remote/route_plan_remote_datasource.dart';
import 'package:harvest_app/data/repositories/route_plan_repository_impl.dart';
import 'package:harvest_app/domain/repositories/route_plan_repository.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/create_route_plan_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/get_route_plan_detail_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/get_route_plans_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/update_route_status_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/update_stop_status_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/reorder_stops_usecase.dart';
import 'package:harvest_app/domain/usecases/producer/route_plan/push_location_usecase.dart';
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
UpdateRouteStatusUseCase updateRouteStatusUseCase(Ref ref) {
  return UpdateRouteStatusUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
UpdateStopStatusUseCase updateStopStatusUseCase(Ref ref) {
  return UpdateStopStatusUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
ReorderStopsUseCase reorderStopsUseCase(Ref ref) {
  return ReorderStopsUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
PushLocationUseCase pushLocationUseCase(Ref ref) {
  return PushLocationUseCase(ref.watch(routePlanRepositoryProvider));
}

@riverpod
class RoutePlanController extends _$RoutePlanController {
  late String _currentDate;

  Timer? _locationTimer;
  StreamSubscription<Position>? _positionStream;

  @override
  RoutePlanState build() {
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fetchRoutePlans(_currentDate);
    
    ref.onDispose(() {
      _stopLocationPolling();
    });
    
    return const RoutePlanState.loading();
  }

  void _checkAndManagePolling(RoutePlanState currentState) {
    currentState.maybeWhen(
      data: (routes) {
        if (routes.isNotEmpty) {
          final route = routes.first;
          if (route.status == 'in_progress' && route.trackingEnabled) {
            _startLocationPolling(route.routeId);
          } else {
            _stopLocationPolling();
          }
        }
      },
      orElse: () => _stopLocationPolling(),
    );
  }

  Future<void> _fetchRoutePlans(String date) async {
    state = const RoutePlanState.loading();
    final result = await ref.read(getRoutePlansUseCaseProvider).call(date);

    result.fold(
      (failure) => state = RoutePlanState.error(failure.message),
      (data) {
        final newState = RoutePlanState.data(data);
        state = newState;
        _checkAndManagePolling(newState);
      },
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
        _fetchRoutePlans(_currentDate);
        return true;
      },
    );
  }

  Future<bool> updateRouteStatus(String routeId, String status) async {
    final result = await ref.read(updateRouteStatusUseCaseProvider).call(routeId, status);
    return result.fold(
      (failure) => false,
      (data) {
        _fetchRoutePlans(_currentDate);
        return true;
      },
    );
  }

  Future<bool> updateStopStatus(String routeId, String stopId, String status, {String? notes}) async {
    final result = await ref.read(updateStopStatusUseCaseProvider).call(routeId, stopId, status, notes: notes);
    return result.fold(
      (failure) => false,
      (data) {
        _fetchRoutePlans(_currentDate);
        return true;
      },
    );
  }

  Future<bool> reorderStops(String routeId, List<String> stopIds) async {
    final result = await ref.read(reorderStopsUseCaseProvider).call(routeId, stopIds);
    return result.fold(
      (failure) => false,
      (data) {
        _fetchRoutePlans(_currentDate);
        return true;
      },
    );
  }

  void _startLocationPolling(String routeId) async {
    if (_locationTimer != null || _positionStream != null) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // Use a periodic timer to push location every 30 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        await ref.read(pushLocationUseCaseProvider).call(
              routeId,
              position.latitude,
              position.longitude,
              accuracy: position.accuracy,
            );
      } catch (e) {
        // Silently ignore tracking errors in background
      }
    });
  }

  void _stopLocationPolling() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _positionStream?.cancel();
    _positionStream = null;
  }
}
