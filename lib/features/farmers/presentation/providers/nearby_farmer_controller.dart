import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/get_nearby_farmers_usecase.dart';
import 'nearby_farmer_providers.dart';
import 'nearby_farmer_state.dart';

part 'nearby_farmer_controller.g.dart';

@riverpod
class NearbyFarmerController extends _$NearbyFarmerController {
  @override
  NearbyFarmerState build() {
    Future.microtask(() => _fetchData());
    return const NearbyFarmerState.loading();
  }

  Future<void> _fetchData() async {
    final currentData = state.mapOrNull(data: (d) => d);
    state = const NearbyFarmerState.loading();
    
    try {
      final usecase = ref.read(getNearbyFarmersUsecaseProvider);
      
      final params = GetNearbyFarmersParams(
        latitude: -6.200000,
        longitude: 106.816666,
        radius: 3.0,
        search: currentData?.searchQuery.isNotEmpty == true ? currentData!.searchQuery : null,
        isOrganic: currentData?.isOrganicFilter == true ? true : null,
        isOpenNow: currentData?.isOpenNowFilter == true ? true : null,
      );

      final result = await usecase(params);

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
          );
        },
      );
    } catch (e) {
      state = NearbyFarmerState.error(e.toString());
    }
  }

  void updateSearchQuery(String query) {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(searchQuery: query);
        _fetchData();
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
}
