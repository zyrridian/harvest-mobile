import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/farmer.dart';
import '../../../domain/entities/harvest_schedule.dart';
import '../../../domain/entities/pre_order.dart';

// --- STATE PROVIDERS ---

/// User's current location
final userLocationProvider = StateProvider<UserLocation?>((ref) => null);

/// User's preferred radius for nearby farmers (in km)
final preferredRadiusProvider = StateProvider<double>((ref) => 10.0);

/// User's followed/subscribed farmers
final subscribedFarmerIdsProvider = StateProvider<List<String>>((ref) => []);

class UserLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime updatedAt;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.updatedAt,
  });
}

// --- DUMMY DATA ---

final _dummyFarmersWithHarvest = [
  Farmer(
    id: 'farmer_001',
    name: 'Green Valley Farm',
    description: 'Organic vegetables grown with love since 2015',
    profileImage:
        'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    coverImage:
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
    latitude: -6.9147,
    longitude: 107.6098,
    address: 'Jl. Setiabudi No. 45',
    city: 'Bandung',
    state: 'West Java',
    rating: 4.8,
    totalReviews: 234,
    totalProducts: 28,
    specialties: ['Organic Vegetables', 'Herbs'],
    isVerified: true,
    hasMapFeature: true,
    phoneNumber: '+6281234567890',
    email: 'greenvalley@farm.com',
    joinedDate: DateTime(2015, 3, 15),
    isOnline: true,
    distance: 2.3,
    acceptsPreOrders: true,
    upcomingHarvestCount: 3,
    nextHarvestDate: DateTime.now().add(const Duration(days: 2)),
    upcomingProducts: ['Tomatoes', 'Lettuce', 'Spinach'],
    status: FarmerStatus.active,
    isSubscribedByUser: true,
    subscriberCount: 156,
    isWithinUserRadius: true,
    operatingDays: ['Monday', 'Wednesday', 'Friday', 'Saturday'],
    operatingHours: '06:00 - 14:00',
    isCurrentlyOperating: true,
    perishableProductCount: 22,
    regularProductCount: 6,
    avgDeliveryTime: 2.5,
  ),
  Farmer(
    id: 'farmer_002',
    name: 'Sunrise Organic',
    description: 'Premium fruits from the highlands',
    profileImage:
        'https://images.unsplash.com/photo-1595855759920-86582396756a?w=200',
    coverImage:
        'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=800',
    latitude: -6.8947,
    longitude: 107.6298,
    address: 'Jl. Lembang No. 12',
    city: 'Lembang',
    state: 'West Java',
    rating: 4.9,
    totalReviews: 189,
    totalProducts: 15,
    specialties: ['Fruits', 'Berries'],
    isVerified: true,
    hasMapFeature: true,
    phoneNumber: '+6281234567891',
    email: 'sunrise@organic.com',
    joinedDate: DateTime(2018, 6, 20),
    isOnline: true,
    distance: 4.5,
    acceptsPreOrders: true,
    upcomingHarvestCount: 2,
    nextHarvestDate: DateTime.now().add(const Duration(days: 5)),
    upcomingProducts: ['Strawberries', 'Avocados'],
    status: FarmerStatus.active,
    isSubscribedByUser: false,
    subscriberCount: 245,
    isWithinUserRadius: true,
    operatingDays: ['Tuesday', 'Thursday', 'Saturday', 'Sunday'],
    operatingHours: '07:00 - 15:00',
    isCurrentlyOperating: false,
    perishableProductCount: 12,
    regularProductCount: 3,
    avgDeliveryTime: 3.0,
  ),
  Farmer(
    id: 'farmer_003',
    name: 'Happy Chicken Farm',
    description: 'Free-range eggs and poultry',
    profileImage:
        'https://images.unsplash.com/photo-1569288063477-83f6a49e2d68?w=200',
    coverImage:
        'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=800',
    latitude: -6.9347,
    longitude: 107.5898,
    address: 'Jl. Cihampelas No. 78',
    city: 'Bandung',
    state: 'West Java',
    rating: 4.7,
    totalReviews: 312,
    totalProducts: 8,
    specialties: ['Eggs', 'Poultry'],
    isVerified: true,
    hasMapFeature: false,
    phoneNumber: '+6281234567892',
    email: 'happy@chicken.com',
    joinedDate: DateTime(2019, 1, 10),
    isOnline: false,
    distance: 3.8,
    acceptsPreOrders: true,
    upcomingHarvestCount: 1,
    nextHarvestDate: DateTime.now().add(const Duration(days: 1)),
    upcomingProducts: ['Fresh Eggs'],
    status: FarmerStatus.active,
    isSubscribedByUser: true,
    subscriberCount: 89,
    isWithinUserRadius: true,
    operatingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    operatingHours: '05:00 - 12:00',
    isCurrentlyOperating: true,
    perishableProductCount: 6,
    regularProductCount: 2,
    avgDeliveryTime: 1.5,
  ),
];

final _dummyHarvestSchedules = [
  HarvestSchedule(
    id: 'harvest_001',
    farmerId: 'farmer_001',
    farmerName: 'Green Valley Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    productId: 'prod_tomato_001',
    productName: 'Organic Tomatoes',
    productImage:
        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
    category: 'Vegetables',
    plannedHarvestDate: DateTime.now().add(const Duration(days: 2)),
    estimatedQuantity: 50,
    unit: 'kg',
    estimatedPricePerUnit: 25000,
    status: HarvestStatus.upcoming,
    acceptsPreOrders: true,
    preOrderCount: 12,
    preOrderQuantity: 28,
    availableQuantity: 22,
    farmerLatitude: -6.9147,
    farmerLongitude: 107.6098,
    distanceFromUser: 2.3,
    isOrganic: true,
    description: 'Fresh organic tomatoes, perfect for salads and cooking',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    updatedAt: DateTime.now(),
  ),
  HarvestSchedule(
    id: 'harvest_002',
    farmerId: 'farmer_001',
    farmerName: 'Green Valley Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    productId: 'prod_lettuce_001',
    productName: 'Butterhead Lettuce',
    productImage:
        'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
    category: 'Vegetables',
    plannedHarvestDate: DateTime.now().add(const Duration(days: 3)),
    estimatedQuantity: 100,
    unit: 'pcs',
    estimatedPricePerUnit: 8000,
    status: HarvestStatus.upcoming,
    acceptsPreOrders: true,
    preOrderCount: 8,
    preOrderQuantity: 35,
    availableQuantity: 65,
    farmerLatitude: -6.9147,
    farmerLongitude: 107.6098,
    distanceFromUser: 2.3,
    isOrganic: true,
    description: 'Crisp and tender butterhead lettuce',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now(),
  ),
  HarvestSchedule(
    id: 'harvest_003',
    farmerId: 'farmer_002',
    farmerName: 'Sunrise Organic',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1595855759920-86582396756a?w=200',
    productId: 'prod_strawberry_001',
    productName: 'Fresh Strawberries',
    productImage:
        'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
    category: 'Fruits',
    plannedHarvestDate: DateTime.now().add(const Duration(days: 5)),
    estimatedQuantity: 30,
    unit: 'kg',
    estimatedPricePerUnit: 85000,
    status: HarvestStatus.upcoming,
    acceptsPreOrders: true,
    preOrderCount: 15,
    preOrderQuantity: 18,
    availableQuantity: 12,
    farmerLatitude: -6.8947,
    farmerLongitude: 107.6298,
    distanceFromUser: 4.5,
    isOrganic: true,
    description: 'Sweet highland strawberries, limited quantity!',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
  ),
  HarvestSchedule(
    id: 'harvest_004',
    farmerId: 'farmer_003',
    farmerName: 'Happy Chicken Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1569288063477-83f6a49e2d68?w=200',
    productId: 'prod_eggs_001',
    productName: 'Free-Range Eggs',
    productImage:
        'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
    category: 'Dairy & Eggs',
    plannedHarvestDate: DateTime.now().add(const Duration(days: 1)),
    estimatedQuantity: 200,
    unit: 'pcs',
    estimatedPricePerUnit: 3500,
    status: HarvestStatus.upcoming,
    acceptsPreOrders: true,
    preOrderCount: 25,
    preOrderQuantity: 150,
    availableQuantity: 50,
    farmerLatitude: -6.9347,
    farmerLongitude: 107.5898,
    distanceFromUser: 3.8,
    isOrganic: false,
    description: 'Fresh free-range eggs collected daily',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  HarvestSchedule(
    id: 'harvest_005',
    farmerId: 'farmer_001',
    farmerName: 'Green Valley Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    productId: 'prod_spinach_001',
    productName: 'Baby Spinach',
    productImage:
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
    category: 'Vegetables',
    plannedHarvestDate: DateTime.now().add(const Duration(days: 4)),
    estimatedQuantity: 40,
    unit: 'kg',
    estimatedPricePerUnit: 35000,
    status: HarvestStatus.upcoming,
    acceptsPreOrders: true,
    preOrderCount: 5,
    preOrderQuantity: 10,
    availableQuantity: 30,
    farmerLatitude: -6.9147,
    farmerLongitude: 107.6098,
    distanceFromUser: 2.3,
    isOrganic: true,
    description: 'Tender baby spinach leaves, perfect for smoothies',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
  ),
];

final _dummyPreOrders = [
  PreOrder(
    id: 'preorder_001',
    userId: 'user_001',
    harvestScheduleId: 'harvest_001',
    farmerId: 'farmer_001',
    farmerName: 'Green Valley Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    productId: 'prod_tomato_001',
    productName: 'Organic Tomatoes',
    productImage:
        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
    quantity: 3,
    unit: 'kg',
    pricePerUnit: 25000,
    totalPrice: 75000,
    depositAmount: 20000,
    depositPaid: true,
    status: PreOrderStatus.confirmed,
    harvestDate: DateTime.now().add(const Duration(days: 2)),
    deliveryMethod: DeliveryMethod.delivery,
    deliveryAddressId: 'addr_001',
    deliveryAddress: 'Jl. Merdeka No. 123, Bandung',
    notes: 'Please pick the reddest ones',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
  ),
  PreOrder(
    id: 'preorder_002',
    userId: 'user_001',
    harvestScheduleId: 'harvest_004',
    farmerId: 'farmer_003',
    farmerName: 'Happy Chicken Farm',
    farmerProfileImage:
        'https://images.unsplash.com/photo-1569288063477-83f6a49e2d68?w=200',
    productId: 'prod_eggs_001',
    productName: 'Free-Range Eggs',
    productImage:
        'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
    quantity: 30,
    unit: 'pcs',
    pricePerUnit: 3500,
    totalPrice: 105000,
    status: PreOrderStatus.pending,
    harvestDate: DateTime.now().add(const Duration(days: 1)),
    deliveryMethod: DeliveryMethod.pickup,
    pickupLocation: 'Happy Chicken Farm, Jl. Cihampelas No. 78',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
];

// --- PROVIDERS ---

/// Get all nearby farmers with upcoming harvests
final nearbyFarmersWithHarvestProvider =
    FutureProvider<List<Farmer>>((ref) async {
  // Simulate API call
  await Future.delayed(const Duration(milliseconds: 500));

  final radius = ref.watch(preferredRadiusProvider);
  return _dummyFarmersWithHarvest
      .where((f) => f.distance <= radius && f.upcomingHarvestCount > 0)
      .toList();
});

/// Get all upcoming harvest schedules within radius
final upcomingHarvestsProvider =
    FutureProvider<List<HarvestSchedule>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));

  final radius = ref.watch(preferredRadiusProvider);
  return _dummyHarvestSchedules
      .where((h) => h.distanceFromUser != null && h.distanceFromUser! <= radius)
      .toList()
    ..sort((a, b) => a.plannedHarvestDate.compareTo(b.plannedHarvestDate));
});

/// Get harvest schedules for a specific farmer
final farmerHarvestSchedulesProvider =
    FutureProvider.family<List<HarvestSchedule>, String>((ref, farmerId) async {
  await Future.delayed(const Duration(milliseconds: 300));

  return _dummyHarvestSchedules.where((h) => h.farmerId == farmerId).toList();
});

/// Get user's pre-orders
final userPreOrdersProvider = FutureProvider<List<PreOrder>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return _dummyPreOrders;
});

/// Get pre-order by ID
final preOrderByIdProvider =
    FutureProvider.family<PreOrder?, String>((ref, id) async {
  await Future.delayed(const Duration(milliseconds: 300));
  try {
    return _dummyPreOrders.firstWhere((p) => p.id == id);
  } catch (e) {
    return null;
  }
});

/// Get harvest alerts for subscribed farmers
final harvestAlertsProvider =
    FutureProvider<List<UpcomingHarvestAlert>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));

  final subscribedIds = ref.watch(subscribedFarmerIdsProvider);
  final farmersWithHarvest = _dummyFarmersWithHarvest
      .where((f) => f.upcomingHarvestCount > 0)
      .toList();

  return farmersWithHarvest
      .map((f) => UpcomingHarvestAlert(
            farmerId: f.id,
            farmerName: f.name,
            farmerProfileImage: f.profileImage,
            distanceKm: f.distance,
            upcomingHarvestCount: f.upcomingHarvestCount,
            nextHarvestDate: f.nextHarvestDate!,
            products: f.upcomingProducts ?? [],
            isSubscribed: subscribedIds.contains(f.id),
          ))
      .toList();
});

/// Get pre-order summary for user
final preOrderSummaryProvider = FutureProvider<PreOrderSummary>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));

  final preOrders = _dummyPreOrders;
  return PreOrderSummary(
    totalPending:
        preOrders.where((p) => p.status == PreOrderStatus.pending).length,
    totalConfirmed:
        preOrders.where((p) => p.status == PreOrderStatus.confirmed).length,
    totalCompleted:
        preOrders.where((p) => p.status == PreOrderStatus.completed).length,
    upcomingThisWeek: preOrders.where((p) => p.daysUntilHarvest <= 7).length,
    totalSpent: preOrders.fold(0, (sum, p) => sum + p.totalPrice),
  );
});

/// Check if user is subscribed to a farmer
final isSubscribedToFarmerProvider =
    Provider.family<bool, String>((ref, farmerId) {
  final subscribedIds = ref.watch(subscribedFarmerIdsProvider);
  return subscribedIds.contains(farmerId);
});

// --- NOTIFIERS FOR ACTIONS ---

class NearbyFarmersNotifier extends StateNotifier<AsyncValue<List<Farmer>>> {
  final Ref ref;

  NearbyFarmersNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadNearbyFarmers();
  }

  Future<void> loadNearbyFarmers() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final radius = ref.read(preferredRadiusProvider);
      final farmers =
          _dummyFarmersWithHarvest.where((f) => f.distance <= radius).toList();
      state = AsyncValue.data(farmers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleSubscription(String farmerId) async {
    final subscribedIds = ref.read(subscribedFarmerIdsProvider);
    if (subscribedIds.contains(farmerId)) {
      ref.read(subscribedFarmerIdsProvider.notifier).state =
          subscribedIds.where((id) => id != farmerId).toList();
    } else {
      ref.read(subscribedFarmerIdsProvider.notifier).state = [
        ...subscribedIds,
        farmerId
      ];
    }
  }

  void updateRadius(double radius) {
    ref.read(preferredRadiusProvider.notifier).state = radius;
    loadNearbyFarmers();
  }
}

final nearbyFarmersNotifierProvider =
    StateNotifierProvider<NearbyFarmersNotifier, AsyncValue<List<Farmer>>>(
        (ref) {
  return NearbyFarmersNotifier(ref);
});
