import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'marketplace_state.dart';

part 'marketplace_controller.g.dart';

@riverpod
class MarketplaceController extends _$MarketplaceController {
  @override
  MarketplaceState build() {
    _fetchData();
    return const MarketplaceState.loading();
  }

  Future<void> _fetchData() async {
    state = const MarketplaceState.loading();
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Prepare API request
    // Here we would use a usecase to fetch the actual data
    // final result = await ref.read(getMarketplaceUseCaseProvider).call(
    //   latitude: userLatitude,
    //   longitude: userLongitude,
    //   filters: ['all', 'nearest'],
    // );
    
    // Dummy Data based on the design
    final flashHarvest = FlashHarvest(
      id: 'fh1',
      title: 'Bandung Strawberries',
      subtitle: 'Picked this morning',
      distance: '0.7 km away',
      imageUrl: '🍓',
    );

    final categories = [
      MarketplaceCategory(id: 'c1', name: 'Vegetables', iconPath: '🥦', gradientColors: [0xFFD4E2D4, 0xFFB8C6B8]),
      MarketplaceCategory(id: 'c2', name: 'Fruits', iconPath: '🍉', gradientColors: [0xFFFFE5D9, 0xFFFFD1BC]),
      MarketplaceCategory(id: 'c3', name: 'Fish', iconPath: '🐟', gradientColors: [0xFFDBEAFE, 0xFF93C5FD]),
      MarketplaceCategory(id: 'c4', name: 'Meat', iconPath: '🥩', gradientColors: [0xFFF2E6E6, 0xFFE6D0D0]),
      MarketplaceCategory(id: 'c5', name: 'Dairy', iconPath: '🧀', gradientColors: [0xFFFFF9E6, 0xFFFFF0C2]),
      MarketplaceCategory(id: 'c6', name: 'Grains', iconPath: '🌾', gradientColors: [0xFFF0EAD6, 0xFFE6DEBF]),
    ];

    final products = [
      MarketplaceProduct(
        id: 'p1',
        name: 'Bayam Organik',
        farmerName: 'Sunrise Organic',
        price: 8000,
        unit: 'bunch',
        imageUrl: '🥬',
        rating: 4.9,
        soldCount: 120,
        isFresh: true,
      ),
      MarketplaceProduct(
        id: 'p2',
        name: 'Strawberry Lokal',
        farmerName: 'Green Valley Farm',
        price: 35000,
        unit: 'kg',
        imageUrl: '🍓',
        rating: 4.8,
        soldCount: 89,
        isFresh: true,
      ),
      MarketplaceProduct(
        id: 'p3',
        name: 'Ikan Mas Segar',
        farmerName: 'Fish Factory',
        price: 45000,
        unit: 'kg',
        imageUrl: '🐟',
        rating: 4.7,
        soldCount: 55,
      ),
      MarketplaceProduct(
        id: 'p4',
        name: 'Wortel Bandung',
        farmerName: 'Fresh Fields Co.',
        price: 12000,
        unit: 'kg',
        imageUrl: '🥕',
        rating: 4.9,
        soldCount: 200,
        isFresh: true,
      ),
    ];

    state = MarketplaceState.data(MarketplaceData(
      flashHarvest: flashHarvest,
      categories: categories,
      products: products,
    ));
  }
}
