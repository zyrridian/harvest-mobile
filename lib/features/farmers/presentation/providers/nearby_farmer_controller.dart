import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/get_nearby_farmers_usecase.dart';
import 'nearby_farmer_providers.dart';
import 'nearby_farmer_state.dart';

part 'nearby_farmer_controller.g.dart';

@riverpod
class NearbyFarmerController extends _$NearbyFarmerController {
  Timer? _debounceTimer;
  double? _lat;
  double? _lng;
  int _fetchId = 0;

  @override
  NearbyFarmerState build() {
    Future.microtask(() => _fetchData());
    return const NearbyFarmerState.loading();
  }

  Future<void> _fetchData() async {
    final fetchId = ++_fetchId;
    final currentData = state.mapOrNull(data: (d) => d);
    if (currentData == null) {
      state = const NearbyFarmerState.loading();
    } else {
      state = currentData.copyWith(isLoading: true);
    }
    
    try {
      final usecase = ref.read(getNearbyFarmersUsecaseProvider);
      
      final params = GetNearbyFarmersParams(
        latitude: _lat ?? -6.200000,
        longitude: _lng ?? 106.816666,
        radius: currentData?.radius ?? 3.0,
        search: currentData?.searchQuery.isNotEmpty == true ? currentData!.searchQuery : null,
        isOrganic: currentData?.isOrganicFilter == true ? true : null,
        isOpenNow: currentData?.isOpenNowFilter == true ? true : null,
      );

      final result = await usecase(params);

      if (fetchId != _fetchId) return;

      result.fold(
        (failure) {
          state = NearbyFarmerState.error(failure.message);
        },
        (farmers) {
          state = NearbyFarmerState.data(
            farmers: farmers,
            searchQuery: currentData?.searchQuery ?? '',
            isOrganicFilter: currentData?.isOrganicFilter ?? false,
            isOpenNowFilter: currentData?.isOpenNowFilter ?? false,
            radius: currentData?.radius ?? 3.0,
            isLoading: false,
          );
        },
      );
    } catch (e) {
      state = NearbyFarmerState.error(e.toString());
    }
  }

  void updateSearchQuery(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(searchQuery: query);
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          _fetchData();
        });
      },
    );
  }

  void toggleOrganicFilter() {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(isOrganicFilter: !data.isOrganicFilter);
        _fetchData();
      },
    );
  }

  void toggleOpenNowFilter() {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(isOpenNowFilter: !data.isOpenNowFilter);
        _fetchData();
      },
    );
  }

  void updateRadius(double radius) {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(radius: radius);
        _fetchData();
      },
    );
  }

  void setLocation(double lat, double lng) {
    _lat = lat;
    _lng = lng;
    _fetchData();
  }
}
