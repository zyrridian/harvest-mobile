import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'nearby_farmer_state.dart';

part 'nearby_farmer_controller.g.dart';

@riverpod
class NearbyFarmerController extends _$NearbyFarmerController {
  final _allFarmers = [
    NearbyFarmerData(
      id: 'f1',
      name: 'Sunrise Organic',
      distance: 0.7,
      category: 'Vegetables',
      subCategory: 'Certified organic',
      rating: 4.9,
      reviewCount: 120,
      tags: ['Organic', 'Pre-order open'],
      products: [NearbyFarmerProduct(name: 'Spinach'), NearbyFarmerProduct(name: 'Tomato')],
      extraProductsCount: 5,
      statusText: 'Open now',
      statusSubText: 'closes 5 PM',
      isOpen: true,
      latitude: -6.200000,
      longitude: 106.816666,
      iconPath: '🥬',
    ),
    NearbyFarmerData(
      id: 'f2',
      name: 'Green Valley Farm',
      distance: 1.7,
      category: 'Fruits',
      subCategory: 'Mixed produce',
      rating: 4.8,
      reviewCount: 89,
      tags: ['Community seller'],
      products: [NearbyFarmerProduct(name: 'Strawberry'), NearbyFarmerProduct(name: 'Mango')],
      extraProductsCount: 3,
      statusText: 'Open now',
      statusSubText: 'closes 6 PM',
      isOpen: true,
      latitude: -6.210000,
      longitude: 106.820000,
      iconPath: '🥦',
    ),
    NearbyFarmerData(
      id: 'f3',
      name: 'Fish Factory',
      distance: 2.6,
      category: 'Aquaculture',
      subCategory: 'Fresh catch',
      rating: 4.7,
      reviewCount: 55,
      tags: ['Pre-order open'],
      products: [NearbyFarmerProduct(name: 'Salmon'), NearbyFarmerProduct(name: 'Crab'), NearbyFarmerProduct(name: 'Lobster')],
      extraProductsCount: 0,
      statusText: 'Opens tomorrow 6 AM',
      statusSubText: '',
      isOpen: false,
      latitude: -6.190000,
      longitude: 106.810000,
      iconPath: '🐟',
    ),
  ];

  @override
  NearbyFarmerState build() {
    _fetchData();
    return const NearbyFarmerState.loading();
  }

  Future<void> _fetchData() async {
    state = const NearbyFarmerState.loading();
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    state = NearbyFarmerState.data(farmers: _allFarmers);
  }

  void updateSearchQuery(String query) {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(searchQuery: query);
        _applyFilters();
      },
    );
  }

  void toggleOrganicFilter() {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(isOrganicFilter: !data.isOrganicFilter);
        _applyFilters();
      },
    );
  }

  void toggleOpenNowFilter() {
    state.mapOrNull(
      data: (data) {
        state = data.copyWith(isOpenNowFilter: !data.isOpenNowFilter);
        _applyFilters();
      },
    );
  }

  void _applyFilters() {
    state.mapOrNull(
      data: (data) {
        List<NearbyFarmerData> filtered = _allFarmers;

        if (data.searchQuery.isNotEmpty) {
          final query = data.searchQuery.toLowerCase();
          filtered = filtered.where((f) {
            return f.name.toLowerCase().contains(query) ||
                f.category.toLowerCase().contains(query) ||
                f.subCategory.toLowerCase().contains(query);
          }).toList();
        }

        if (data.isOrganicFilter) {
          filtered = filtered.where((f) => f.tags.contains('Organic')).toList();
        }

        if (data.isOpenNowFilter) {
          filtered = filtered.where((f) => f.isOpen).toList();
        }

        state = data.copyWith(farmers: filtered);
      },
    );
  }
}
