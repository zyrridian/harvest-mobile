import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to add this package
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/domain/entities/home.dart';
import 'package:harvest_app/presentation/features/search/screens/search_screen.dart';
import 'package:harvest_app/presentation/features/category/screens/category_screen.dart';
import 'package:harvest_app/presentation/features/home/providers/home_controller.dart';
import 'package:harvest_app/presentation/features/home/providers/home_state.dart';
import 'package:harvest_app/presentation/shared_widgets/app_cached_image.dart';
import 'package:harvest_app/presentation/providers/harvest_providers.dart';
import 'package:harvest_app/domain/entities/harvest_schedule.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

// --- NEW 2025 DESIGN COLORS ---
const kBgColor = Color(0xFFFAFAF8); // Warm off-white
const kDarkGreen = Color(0xFF1A2F25); // Deep Forest
const kAccentOrange = Color(0xFFE86A33); // Burnt Orange
const kPillGrey = Color(0xFFF0F2F0); // Stone Grey
const kFreshGreen = Color(0xFF10B981); // Fresh/Success green
const kPreOrderBlue = Color(0xFF3B82F6); // Pre-order blue

// Mock data models
// Don't forget to update your Category class to include the optional icon!
class Category {
  final String id;
  final String name;
  final String emoji;
  final IconData? icon; // Added this optional field
  final List<Color> gradient;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.icon,
    required this.gradient,
  });
}

class FarmerProfile {
  final String id;
  final String name;
  final String location;
  final double distance;
  final double rating;
  final String imageUrl;
  final bool hasUpcomingHarvest;
  final int upcomingHarvestCount;
  final DateTime? nextHarvestDate;
  final List<String> upcomingProducts;
  final bool isSubscribed;

  FarmerProfile({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    this.hasUpcomingHarvest = false,
    this.upcomingHarvestCount = 0,
    this.nextHarvestDate,
    this.upcomingProducts = const [],
    this.isSubscribed = false,
  });
}

class Product {
  final String id;
  final String name;
  final String seller;
  final double price;
  final String unit;
  final String imageUrl;
  final bool isPremium;
  final double? rating;
  final bool isPerishable;
  final bool acceptsPreOrder;
  final DateTime? harvestDate;
  final int? daysUntilHarvest;

  Product({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.isPremium = false,
    this.rating,
    this.isPerishable = false,
    this.acceptsPreOrder = false,
    this.harvestDate,
    this.daysUntilHarvest,
  });
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationAndFetch();
    });
  }

  Future<void> _checkLocationAndFetch() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDeniedForeverDialog();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        ref.read(homeControllerProvider.notifier).refresh(
              latitude: position.latitude,
              longitude: position.longitude,
              radius: 10.0,
            );
      }
    } catch (e) {
      // Handle error quietly
    }
  }

  void _showLocationDeniedDialog() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Location access denied. Showing default nearby farmers.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _checkLocationAndFetch();
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLocationDeniedForeverDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Required'),
        content: const Text(
            'Location permissions are permanently denied. Please enable them in your device settings to see farmers near you.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  // Updated Categories to match the "Earth Tone Gradients"
  // 1. Updated Model to handle both Emojis (for food) and Icons (for "More")
  final List<Category> categories = [
    Category(
      id: 'vegetables',
      name: 'Vegetables', // Restored full name
      emoji: '🥦',
      gradient: [
        const Color(0xFFD4E2D4),
        const Color(0xFFB8C6B8)
      ], // Sage Green
    ),
    Category(
      id: 'fruits',
      name: 'Fruits',
      emoji: '🍓',
      gradient: [const Color(0xFFFFE5D9), const Color(0xFFFFD1BC)], // Peach
    ),
    Category(
      id: 'meat',
      name: 'Meat',
      emoji: '🥩',
      gradient: [const Color(0xFFF2E6E6), const Color(0xFFE6D0D0)], // Rose
    ),
    Category(
      id: 'fish',
      name: 'Fish', // Restored
      emoji: '🐟',
      gradient: [
        const Color(0xFFDBEAFE),
        const Color(0xFF93C5FD)
      ], // Ocean Blue
    ),
    Category(
      id: 'dairy',
      name: 'Dairy',
      emoji: '🧀',
      gradient: [const Color(0xFFFFF9E6), const Color(0xFFFFF0C2)], // Cream
    ),
    Category(
      id: 'eggs',
      name: 'Eggs', // Restored
      emoji: '🥚',
      gradient: [
        const Color(0xFFFEF9C3),
        const Color(0xFFFDE047)
      ], // Pale Yellow
    ),
    Category(
      id: 'grains',
      name: 'Grains',
      emoji: '🌾',
      gradient: [const Color(0xFFF0EAD6), const Color(0xFFE6DEBF)], // Wheat
    ),
    Category(
      id: 'more',
      name: 'More', // Restored Button
      emoji: '', // Empty emoji, we will use an Icon for this one
      icon: Icons.grid_view_rounded, // Specific Icon for "More"
      gradient: [
        const Color(0xFFF3F4F6),
        const Color(0xFFD1D5DB)
      ], // Neutral Grey
    ),
  ];

  // Updated farmer data with harvest info
  final List<FarmerProfile> nearbyFarmers = [
    FarmerProfile(
      id: 'farmer_001',
      name: 'Green Valley Farm',
      location: 'North District',
      distance: 1.2,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=200',
      hasUpcomingHarvest: true,
      upcomingHarvestCount: 3,
      nextHarvestDate: DateTime.now().add(const Duration(days: 2)),
      upcomingProducts: ['Tomatoes', 'Lettuce', 'Spinach'],
      isSubscribed: true,
    ),
    FarmerProfile(
      id: 'farmer_002',
      name: 'Sunrise Organic',
      location: 'East Village',
      distance: 2.5,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200',
      hasUpcomingHarvest: true,
      upcomingHarvestCount: 2,
      nextHarvestDate: DateTime.now().add(const Duration(days: 5)),
      upcomingProducts: ['Strawberries', 'Avocados'],
      isSubscribed: false,
    ),
    FarmerProfile(
      id: 'farmer_003',
      name: 'Fresh Fields Co.',
      location: 'West End',
      distance: 3.1,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=200',
      hasUpcomingHarvest: false,
      upcomingHarvestCount: 0,
      isSubscribed: false,
    ),
  ];

  final List<Product> freshToday = [
    Product(
      id: 'lettuce_001',
      name: 'Fresh Lettuce',
      seller: 'Green Valley Farm',
      price: 2.49,
      unit: 'bunch',
      imageUrl:
          'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
      rating: 4.7,
      isPerishable: true,
      harvestDate: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Product(
      id: 'carrots_001',
      name: 'Carrots',
      seller: 'Fresh Fields Co.',
      price: 3.99,
      unit: 'kg',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      rating: 4.6,
      isPerishable: true,
    ),
    Product(
      id: 'peppers_001',
      name: 'Bell Peppers',
      seller: 'Sunrise Organic',
      price: 5.49,
      unit: 'kg',
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      rating: 4.8,
      isPerishable: true,
      acceptsPreOrder: true,
      daysUntilHarvest: 3,
    ),
  ];

  // Dummy data for upcoming harvests (pre-orders available)
  final List<Map<String, dynamic>> upcomingHarvests = [
    {
      'id': 'harvest_001',
      'productName': 'Organic Tomatoes',
      'farmerName': 'Green Valley Farm',
      'farmerImage':
          'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
      'productImage':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
      'harvestDate': DateTime.now().add(const Duration(days: 2)),
      'price': 25000.0,
      'unit': 'kg',
      'availableQty': 22,
      'totalQty': 50,
      'preOrderCount': 12,
      'distance': 2.3,
      'isOrganic': true,
    },
    {
      'id': 'harvest_002',
      'productName': 'Fresh Strawberries',
      'farmerName': 'Sunrise Organic',
      'farmerImage':
          'https://images.unsplash.com/photo-1595855759920-86582396756a?w=200',
      'productImage':
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      'harvestDate': DateTime.now().add(const Duration(days: 5)),
      'price': 85000.0,
      'unit': 'kg',
      'availableQty': 12,
      'totalQty': 30,
      'preOrderCount': 15,
      'distance': 4.5,
      'isOrganic': true,
    },
    {
      'id': 'harvest_003',
      'productName': 'Free-Range Eggs',
      'farmerName': 'Happy Chicken Farm',
      'farmerImage':
          'https://images.unsplash.com/photo-1569288063477-83f6a49e2d68?w=200',
      'productImage':
          'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
      'harvestDate': DateTime.now().add(const Duration(days: 1)),
      'price': 3500.0,
      'unit': 'pcs',
      'availableQty': 50,
      'totalQty': 200,
      'preOrderCount': 25,
      'distance': 3.8,
      'isOrganic': false,
    },
  ];

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: homeState.maybeWhen(
        data: (homeData) {
          final dynamicCategories = homeData.categories.map((c) {
            return Category(
              id: c.slug,
              name: c.name,
              emoji: c.emoji,
              gradient:
                  c.gradientColors.map((hex) => _colorFromHex(hex)).toList(),
            );
          }).toList();

          dynamicCategories.add(Category(
            id: 'more',
            name: 'More',
            emoji: '',
            icon: Icons.grid_view_rounded,
            gradient: [const Color(0xFFF3F4F6), const Color(0xFFD1D5DB)],
          ));

          final apiFreshToday = homeData.freshToday.map((item) {
            return Product(
              id: item.id,
              name: item.name,
              seller: item.farmer.name,
              price: item.price.toDouble(),
              unit: item.unit,
              imageUrl: item.image ??
                  'https://via.placeholder.com/400', // Placeholder if no image
              rating: item.rating.toDouble(),
              isPerishable: true,
            );
          }).toList();

          return _buildContent(
              dynamicCategories, apiFreshToday, homeData.nearbyFarmers.farmers);
        },
        error: (message) => Center(child: Text(message)),
        orElse: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      ),
    );
  }

  Widget _buildContent(List<Category> mappedCategories,
      List<Product> mappedFreshToday, List<HomeFarmer> mappedNearbyFarmers) {
    return CustomScrollView(
      slivers: [
        // 1. HEADER (APP BAR)
        SliverAppBar(
          pinned: true,
          floating: false,
          backgroundColor: kBgColor,
          surfaceTintColor: kBgColor,
          elevation: 0,
          toolbarHeight: 80,
          titleSpacing: 24.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harvest Market.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: kDarkGreen,
                    letterSpacing: -0.5,
                  ),
                ),
                Row(
                  children: [
                    _buildModernIconBtn(
                      icon: Icons.notifications_none_rounded,
                      hasDot: true,
                      onTap: () => context.push(AppRouter.notifications),
                    ),
                    const SizedBox(width: 12),
                    _buildModernIconBtn(
                      icon: Icons.shopping_bag_outlined,
                      hasDot: false,
                      onTap: () => context.push(AppRouter.cart),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 2. FLAT SEARCH BAR
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: kPillGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Icon(Icons.search, color: Colors.grey[500], size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search fresh products...',
                        style: GoogleFonts.dmSans(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(10),
                      child:
                          Icon(Icons.tune_rounded, color: kDarkGreen, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. MODERN CATEGORIES (Earth Tones & Pebbles)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              children: [
                _buildSectionHeader('Shop by Category', showSeeAll: false),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: mappedCategories.length,
                  itemBuilder: (context, index) {
                    return _buildPebbleCategoryCard(mappedCategories[index]);
                  },
                ),
              ],
            ),
          ),
        ),

        // 4. UPCOMING HARVESTS - PRE-ORDER SECTION (NEW)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                _buildSectionHeader(
                  '🌾 Pre-Order Fresh Harvests',
                  onSeeAllTap: () => context.push(AppRouter.products),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reserve perishable items before harvest day',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Upcoming Harvests Horizontal List
        SliverToBoxAdapter(
          child: SizedBox(
            height: 240, // Increased height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: upcomingHarvests.length,
              itemBuilder: (context, index) {
                return _buildUpcomingHarvestCard(upcomingHarvests[index]);
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // 5. NEAR ME (Floating Card Map)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              children: [
                _buildSectionHeader(
                  'Farmers Near You',
                  onSeeAllTap: () => context.push(AppRouter.farmersMap),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: const Color(0xFFE0E8E5), // Map BG color
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        // Abstract Map Painter
                        CustomPaint(
                          size: Size.infinite,
                          painter: MapGridPainter(),
                        ),

                        // Pins
                        Positioned(
                          top: 60,
                          left: 100,
                          child: _buildMapPin(kAccentOrange),
                        ),
                        Positioned(
                          top: 90,
                          right: 80,
                          child: _buildMapPin(kDarkGreen),
                        ),

                        // Floating Overlay Card
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: kDarkGreen.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '3 Markets Open',
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: kDarkGreen,
                                      ),
                                    ),
                                    Text(
                                      'Within 5km range',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.push(AppRouter.farmersMap),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: kDarkGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'View Map',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 5. NEARBY LIST (Cleaned up)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: mappedNearbyFarmers.length,
              itemBuilder: (context, index) {
                return _buildModernFarmerCard(mappedNearbyFarmers[index]);
              },
            ),
          ),
        ),

        // Fresh Today Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: _buildSectionHeader(
              'Fresh Today',
              showSeeAll: true,
              onSeeAllTap: () => context.push(AppRouter.products),
            ),
          ),
        ),

        // Fresh Today Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildGridProductCard(mappedFreshToday[index]);
              },
              childCount: mappedFreshToday.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 85),
        ),
      ],
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionHeader(
    String title, {
    bool showSeeAll = false,
    VoidCallback? onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              'See all',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernIconBtn(
      {required IconData icon,
      required bool hasDot,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E5E0)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: kDarkGreen, size: 20),
            if (hasDot)
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: kAccentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPebbleCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        // Handle "More" click differently if needed
        if (category.id == 'more') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoryScreen(
                categoryName: 'All Categories',
                categoryId: 'all',
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreen(
                categoryName: category.name,
                categoryId: category.id,
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(24), // "Super-ellipse" shape
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: category.gradient,
                ),
              ),
              child: Center(
                child: category.id == 'more'
                    // If it's "More", show the Icon
                    ? Icon(category.icon, color: kDarkGreen, size: 28)
                    // Otherwise show the Emoji
                    : Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kDarkGreen,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
    );
  }

  Widget _buildModernFarmerCard(HomeFarmer farmer) {
    return GestureDetector(
      onTap: () {
        // Navigate to farmer detail screen
        context.push('${AppRouter.farmers}/${farmer.id}');
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0F2F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AppCachedImage(
                      imageUrl: farmer.profileImage ??
                          'https://static.vecteezy.com/system/resources/previews/047/566/732/non_2x/photo-gallery-icon-for-digital-albums-and-media-libraries-vector.jpg',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  // Verified indicator
                  if (farmer.isVerified == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kFreshGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            farmer.name,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kDarkGreen,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (farmer.rating != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: kAccentOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 10, color: kAccentOrange),
                                const SizedBox(width: 2),
                                Text(
                                  farmer.rating.toString(),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: kAccentOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${farmer.distanceKm?.toStringAsFixed(1) ?? '?'}km • ${farmer.address ?? 'Unknown Location'}',
                      style: GoogleFonts.dmSans(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (farmer.totalProducts != null &&
                        farmer.totalProducts! > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.inventory_2, size: 12, color: kFreshGreen),
                          const SizedBox(width: 4),
                          Text(
                            '${farmer.totalProducts} Products Available',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: kFreshGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Upcoming Harvest Pre-Order Card
  Widget _buildUpcomingHarvestCard(Map<String, dynamic> harvest) {
    final harvestDate = harvest['harvestDate'] as DateTime;
    final daysUntil = harvestDate.difference(DateTime.now()).inDays;
    final availableQty = harvest['availableQty'] as int;
    final totalQty = harvest['totalQty'] as int;
    final preOrderPercentage = ((totalQty - availableQty) / totalQty * 100);

    return GestureDetector(
      onTap: () {
        // Navigate to product detail with pre-order mode
        context.push('${AppRouter.products}/${harvest['id']}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kPillGrey),
          boxShadow: [
            BoxShadow(
              color: kDarkGreen.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with harvest countdown badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.network(
                    harvest['productImage'] as String,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                // Harvest countdown badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: daysUntil <= 1 ? kAccentOrange : kDarkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          daysUntil == 0
                              ? 'Today!'
                              : daysUntil == 1
                                  ? 'Tomorrow'
                                  : '$daysUntil days',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Organic badge
                if (harvest['isOrganic'] == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text('🌿', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    harvest['productName'] as String,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundImage: NetworkImage(
                          harvest['farmerImage'] as String,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          harvest['farmerName'] as String,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Pre-order progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${harvest['preOrderCount']} pre-orders',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '$availableQty ${harvest['unit']} left',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: availableQty < 20
                                  ? kAccentOrange
                                  : kDarkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: preOrderPercentage / 100,
                          minHeight: 4,
                          backgroundColor: kPillGrey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            preOrderPercentage > 70
                                ? kAccentOrange
                                : kFreshGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price and pre-order button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(harvest['price']),
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kDarkGreen,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kPreOrderBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Pre-Order',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridProductCard(Product product) {
    return GestureDetector(
      onTap: () => context.push('${AppRouter.products}/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0F2F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AppCachedImage(
                    imageUrl: product.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorAssetImage:
                        'https://static.vecteezy.com/system/resources/previews/047/566/732/non_2x/photo-gallery-icon-for-digital-albums-and-media-libraries-vector.jpg',
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      color: kDarkGreen,
                    ),
                  ),
                  Text(
                    product.seller,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price}',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Minimal Map Painter (Dots instead of lines)
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC4D1CC)
      ..style = PaintingStyle.fill;

    const double step = 20.0;

    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        if ((x + y) % 3 == 0) {
          // Random-ish pattern
          canvas.drawCircle(Offset(x, y), 1.5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
