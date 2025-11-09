import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../data/datasources/remote/farmer_remote_datasource.dart';
import '../../../../data/repositories/farmer_repository_impl.dart';
import '../../../../domain/repositories/farmer_repository.dart';
import '../../../../domain/usecases/farmers/get_farmers.dart';
import '../../../../domain/usecases/farmers/get_nearby_farmers.dart';
import '../../../../domain/usecases/farmers/get_farmer_by_id.dart';
import 'farmers_state.dart';

// Data Source Provider
final farmerRemoteDataSourceProvider = Provider<FarmerRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return FarmerRemoteDataSourceImpl(dio: dio);
});

// Repository Provider
final farmerRepositoryProvider = Provider<FarmerRepository>((ref) {
  final remoteDataSource = ref.watch(farmerRemoteDataSourceProvider);
  return FarmerRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases Providers
final getFarmersUseCaseProvider = Provider<GetFarmers>((ref) {
  return GetFarmers(ref.watch(farmerRepositoryProvider));
});

final getNearbyFarmersUseCaseProvider = Provider<GetNearbyFarmers>((ref) {
  return GetNearbyFarmers(ref.watch(farmerRepositoryProvider));
});

final getFarmerByIdUseCaseProvider = Provider<GetFarmerById>((ref) {
  return GetFarmerById(ref.watch(farmerRepositoryProvider));
});

// State Providers for filters
final farmerSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedSpecialtiesProvider = StateProvider<List<String>>((ref) => []);
final hasMapFeatureFilterProvider = StateProvider<bool?>((ref) => null);
final maxDistanceFilterProvider = StateProvider<double?>((ref) => null);
final minRatingFilterProvider = StateProvider<double?>((ref) => null);
final farmerViewModeProvider =
    StateProvider<FarmerViewMode>((ref) => FarmerViewMode.list);

// Main Controller
final farmersControllerProvider =
    StateNotifierProvider<FarmersController, FarmersState>((ref) {
  return FarmersController(ref);
});

class FarmersController extends StateNotifier<FarmersState> {
  final Ref ref;

  FarmersController(this.ref) : super(const FarmersState.initial()) {
    // Load farmers on initialization
    loadFarmers();
  }

  Future<void> loadFarmers() async {
    state = const FarmersState.loading();

    final query = ref.read(farmerSearchQueryProvider);
    final specialties = ref.read(selectedSpecialtiesProvider);
    final hasMapFeature = ref.read(hasMapFeatureFilterProvider);
    final maxDistance = ref.read(maxDistanceFilterProvider);
    final minRating = ref.read(minRatingFilterProvider);

    final useCase = ref.read(getFarmersUseCaseProvider);
    final result = await useCase(
      query: query.isEmpty ? null : query,
      specialties: specialties.isEmpty ? null : specialties,
      hasMapFeature: hasMapFeature,
      maxDistance: maxDistance,
      minRating: minRating,
    );

    result.fold(
      (failure) => state = FarmersState.error(failure.message),
      (farmers) => state = FarmersState.loaded(farmers),
    );
  }

  Future<void> searchFarmers(String query) async {
    ref.read(farmerSearchQueryProvider.notifier).state = query;
    await loadFarmers();
  }

  Future<void> applyFilters({
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    if (specialties != null) {
      ref.read(selectedSpecialtiesProvider.notifier).state = specialties;
    }
    if (hasMapFeature != null) {
      ref.read(hasMapFeatureFilterProvider.notifier).state = hasMapFeature;
    }
    if (maxDistance != null) {
      ref.read(maxDistanceFilterProvider.notifier).state = maxDistance;
    }
    if (minRating != null) {
      ref.read(minRatingFilterProvider.notifier).state = minRating;
    }
    await loadFarmers();
  }

  Future<void> loadNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    state = const FarmersState.loading();

    final useCase = ref.read(getNearbyFarmersUseCaseProvider);
    final result = await useCase(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );

    result.fold(
      (failure) => state = FarmersState.error(failure.message),
      (farmers) => state = FarmersState.loaded(farmers),
    );
  }

  void clearFilters() {
    ref.read(farmerSearchQueryProvider.notifier).state = '';
    ref.read(selectedSpecialtiesProvider.notifier).state = [];
    ref.read(hasMapFeatureFilterProvider.notifier).state = null;
    ref.read(maxDistanceFilterProvider.notifier).state = null;
    ref.read(minRatingFilterProvider.notifier).state = null;
    loadFarmers();
  }

  void toggleViewMode() {
    final currentMode = ref.read(farmerViewModeProvider);
    ref.read(farmerViewModeProvider.notifier).state =
        currentMode == FarmerViewMode.list
            ? FarmerViewMode.map
            : FarmerViewMode.list;
  }
}
