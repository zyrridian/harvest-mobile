import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/domain/entities/home.dart';
import 'package:harvest_app/features/catalog/presentation/screens/search/search_screen.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_screen.dart';
import 'package:harvest_app/presentation/features/home/providers/home_controller.dart';
import 'package:harvest_app/presentation/features/home/widgets/greeting_location_bar.dart';
import 'package:harvest_app/presentation/features/home/widgets/promo_carousel.dart';
import 'package:harvest_app/presentation/features/home/widgets/quick_action_grid.dart';
import 'package:harvest_app/presentation/features/messaging/screens/conversations_list_screen.dart';
import 'package:harvest_app/presentation/features/order/screens/orders_list_screen.dart';
import 'package:harvest_app/presentation/shared_widgets/app_cached_image.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:harvest_app/domain/entities/farmer.dart';

// ─── Design Tokens ───────────────────────────────────────────────────────────
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);
const kPreOrderBlue = Color(0xFF3B82F6);
const kSage = Color(0xFF7C9070);
const kSand = Color(0xFFF0EAD6);

// ─── Local models ─────────────────────────────────────────────────────────────
class Category {
  final String id;
  final String name;
  final String emoji;
  final IconData? icon;
  final List<Color> gradient;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.icon,
    required this.gradient,
  });
}

class Product {
  final String id;
  final String name;
  final String seller;
  final double price;
  final String unit;
  final String imageUrl;
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
    this.rating,
    this.isPerishable = false,
    this.acceptsPreOrder = false,
    this.harvestDate,
    this.daysUntilHarvest,
  });
}

// ─── Home Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationAndFetch();
    });
  }

  Future<void> _checkLocationAndFetch() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDeniedSnack();
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
    } catch (_) {}
  }

  void _showLocationDeniedSnack() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Location access denied. Showing default farmers.'),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Location Required',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: const Text(
            'Location permissions are permanently denied. Enable them in device settings.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
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

  Future<void> _onRefresh() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position pos = await Geolocator.getCurrentPosition();
        await ref.read(homeControllerProvider.notifier).refresh(
              latitude: pos.latitude,
              longitude: pos.longitude,
              radius: 10.0,
            );
      } else {
        await ref.read(homeControllerProvider.notifier).refresh();
      }
    } catch (_) {
      await ref.read(homeControllerProvider.notifier).refresh();
    }
  }

  // ── Categories ──────────────────────────────────────────────────────────────
  final List<Category> _staticCategories = [
    Category(
      id: 'vegetables',
      name: 'Vegetables',
      emoji: '🥦',
      gradient: [Color(0xFFD4E2D4), Color(0xFFB8C6B8)],
    ),
    Category(
      id: 'fruits',
      name: 'Fruits',
      emoji: '🍓',
      gradient: [Color(0xFFFFE5D9), Color(0xFFFFD1BC)],
    ),
    Category(
      id: 'meat',
      name: 'Meat',
      emoji: '🥩',
      gradient: [Color(0xFFF2E6E6), Color(0xFFE6D0D0)],
    ),
    Category(
      id: 'fish',
      name: 'Fish',
      emoji: '🐟',
      gradient: [Color(0xFFDBEAFE), Color(0xFF93C5FD)],
    ),
    Category(
      id: 'dairy',
      name: 'Dairy',
      emoji: '🧀',
      gradient: [Color(0xFFFFF9E6), Color(0xFFFFF0C2)],
    ),
    Category(
      id: 'eggs',
      name: 'Eggs',
      emoji: '🥚',
      gradient: [Color(0xFFFEF9C3), Color(0xFFFDE047)],
    ),
    Category(
      id: 'grains',
      name: 'Grains',
      emoji: '🌾',
      gradient: [Color(0xFFF0EAD6), Color(0xFFE6DEBF)],
    ),
    Category(
      id: 'more',
      name: 'More',
      emoji: '',
      icon: Icons.grid_view_rounded,
      gradient: [Color(0xFFF3F4F6), Color(0xFFD1D5DB)],
    ),
  ];

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse(hexColor, radix: 16));
  }

  // ── Build ──────────────────────────────────────────────────────────────────
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
              gradient: c.gradientColors.map((h) => _colorFromHex(h)).toList(),
            );
          }).toList();
          dynamicCategories.add(Category(
            id: 'more',
            name: 'More',
            emoji: '',
            icon: Icons.grid_view_rounded,
            gradient: [const Color(0xFFF3F4F6), const Color(0xFFD1D5DB)],
          ));

          final apiFreshToday = homeData.freshToday
              .map((item) => Product(
                    id: item.slug,
                    name: item.name,
                    seller: item.farmer.name,
                    price: item.price.toDouble(),
                    unit: item.unit,
                    imageUrl: item.image ?? AppConstants.placeholderImage,
                    rating: item.rating.toDouble(),
                    isPerishable: true,
                  ))
              .toList();

          return _buildContent(
            dynamicCategories.isNotEmpty
                ? dynamicCategories
                : _staticCategories,
            apiFreshToday,
            homeData.nearbyFarmers.farmers,
            homeData.preOrders,
          );
        },
        error: (message) => Center(child: Text(message)),
        orElse: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      ),
    );
  }

  Widget _buildContent(
    List<Category> categories,
    List<Product> freshToday,
    List<HomeFarmer> nearbyFarmers,
    List<HomePreOrders> preOrders,
  ) {
    return RefreshIndicator(
      color: kDarkGreen,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          // ── 1. HEADER ─────────────────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
            elevation: 0,
            toolbarHeight: 72,
            titleSpacing: 24.0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Harvest leaf logo
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: kDarkGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('🌱', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Harvest',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: kDarkGreen,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _iconBtn(
                        icon: Icons.notifications_none_rounded,
                        hasDot: true,
                        onTap: () => context.push(AppRouter.notifications),
                      ),
                      // const SizedBox(width: 10),
                      // _iconBtn(
                      //   icon: Icons.shopping_bag_outlined,
                      //   onTap: () => context.push(AppRouter.cart),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── 2. SEARCH BAR ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: kPillGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search_rounded,
                          color: Colors.grey[500], size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search fresh products, farmers...',
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kDarkGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.tune_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. GREETING + LOCATION ────────────────────────────────────────
          SliverToBoxAdapter(
            child: GreetingLocationBar(
              locationName: 'Bandung',
              onLocationTap: () => context.push(AppRouter.addresses),
            ),
          ),

          // ── 4. QUICK ACTIONS GRID ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Our Services', showSeeAll: false),
                  // const SizedBox(height: 16),
                  QuickActionGrid(
                    actions: [
                      QuickAction(
                        label: 'Marketplace',
                        iconPath: 'assets/icons/ic_marketplace.svg',
                        onTap: () => context.push(AppRouter.products),
                      ),
                      QuickAction(
                        label: 'Pre-Order',
                        iconPath: 'assets/icons/ic_preorder.svg',
                        badge: 'NEW',
                        isNewBadge: true,
                        onTap: () => context.push(AppRouter.preorder),
                      ),
                      QuickAction(
                        label: 'Harvest Schedule',
                        iconPath: 'assets/icons/ic_harvest_schedule.svg',
                        badge: '3',
                        onTap: () => context.push(AppRouter.harvestSchedule),
                      ),
                      QuickAction(
                        label: 'Nearby Farmers',
                        iconPath: 'assets/icons/ic_nearby_farmer.svg',
                        badge: nearbyFarmers.isNotEmpty
                            ? '${nearbyFarmers.length}'
                            : null,
                        onTap: () => context.push(AppRouter.farmersMap),
                      ),
                      QuickAction(
                        label: 'My Orders',
                        iconPath: 'assets/icons/ic_orders.svg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OrdersListScreen()),
                        ),
                      ),
                      QuickAction(
                        label: 'Chat',
                        iconPath: 'assets/icons/ic_chat.svg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ConversationsListScreen()),
                        ),
                      ),
                      QuickAction(
                        label: 'Promos',
                        iconPath: 'assets/icons/ic_promo.svg',
                        badge: 'HOT',
                        onTap: () {},
                      ),
                      QuickAction(
                        label: 'More',
                        iconData: Icons.more_horiz,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryScreen(
                              categoryName: 'All Categories',
                              categoryId: 'all',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── 5. PROMO CAROUSEL ─────────────────────────────────────────────
          const SliverToBoxAdapter(child: PromoCarousel()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // ── 6. CATEGORIES — horizontal chip row ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 0, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: _sectionHeader(
                      'Shop by Category',
                      showSeeAll: true,
                      onSeeAllTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryScreen(
                            categoryName: 'All Categories',
                            categoryId: 'all',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) =>
                          _buildCategoryChip(categories[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 7. FARMERS NEAR YOU ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: _sectionHeader(
                'Farmers Near You',
                showSeeAll: true,
                onSeeAllTap: () => context.push(AppRouter.farmersMap),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _buildMapPreview(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: nearbyFarmers.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: nearbyFarmers.length,
                      itemBuilder: (context, i) =>
                          _buildFarmerCard(nearbyFarmers[i]),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Text('No farmers found nearby',
                            style: GoogleFonts.inter(color: Colors.grey[500])),
                      ),
                    ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // ── 8. PRE-ORDER HARVESTS ──────────────────────────────────────────
          if (preOrders.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      '🔥 Pre-Order Harvests',
                      showSeeAll: true,
                      onSeeAllTap: () => context.push(AppRouter.products),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reserve fresh produce before harvest day',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 285,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: preOrders.length,
                  itemBuilder: (context, index) =>
                      _buildPreOrderCard(preOrders[index]),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],

          // ── 9. FRESH TODAY ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: _sectionHeader(
                'Fresh Today',
                showSeeAll: true,
                onSeeAllTap: () => context.push(AppRouter.products),
              ),
            ),
          ),
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
                (context, index) => _buildProductCard(freshToday[index]),
                childCount: freshToday.length,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Widget _iconBtn({
    required IconData icon,
    bool hasDot = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E5E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: kDarkGreen, size: 20),
            if (hasDot)
              Positioned(
                top: 9,
                right: 11,
                child: Container(
                  width: 7,
                  height: 7,
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

  Widget _sectionHeader(
    String title, {
    bool showSeeAll = false,
    VoidCallback? onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'See all',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kDarkGreen,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip(Category category) {
    return GestureDetector(
      onTap: () {
        if (category.id == 'more') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(
                categoryName: 'All Categories',
                categoryId: 'all',
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                categoryName: category.name,
                categoryId: category.id,
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: category.gradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: category.id == 'more'
                  ? Icon(category.icon, color: kDarkGreen, size: 26)
                  : Text(
                      category.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kDarkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return GestureDetector(
      onTap: () => context.push(AppRouter.farmersMap),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFE0EDE6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Grid dots map painter
              CustomPaint(
                size: Size.infinite,
                painter: _MapGridPainter(),
              ),
              // Decorative farm road lines
              CustomPaint(
                size: Size.infinite,
                painter: _MapRoadPainter(),
              ),
              // Farmer pins
              Positioned(
                  top: 45, left: 80, child: _mapPin(kAccentOrange, '🧑‍🌾')),
              Positioned(top: 80, right: 90, child: _mapPin(kDarkGreen, '🌾')),
              Positioned(top: 30, right: 50, child: _mapPin(kFreshGreen, '🥦')),
              // Floating overlay
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: kDarkGreen.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
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
                            '🌱 Farmers Near You',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: kDarkGreen,
                            ),
                          ),
                          Text(
                            'Tap to open full map',
                            style: GoogleFonts.inter(
                                fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: kDarkGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Explore',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
    );
  }

  Widget _mapPin(Color color, String emoji) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
        ),
        CustomPaint(
          size: const Size(10, 8),
          painter: _PinTailPainter(color),
        ),
      ],
    );
  }

  Widget _buildFarmerCard(HomeFarmer farmer) {
    return GestureDetector(
      onTap: () {
        final fullFarmer = Farmer(
          id: farmer.id,
          userId: farmer.userId,
          name: farmer.name,
          description: '',
          profileImage: farmer.profileImage,
          coverImage: null,
          latitude: farmer.latitude ?? 0.0,
          longitude: farmer.longitude ?? 0.0,
          address: farmer.address ?? '',
          rating: farmer.rating ?? 0.0,
          totalReviews: 0,
          totalProducts: farmer.totalProducts ?? 0,
          specialties: const [],
          isVerified: farmer.isVerified ?? false,
          hasMapFeature: false,
          joinedDate: DateTime.now(),
          isOnline: false,
          distance: farmer.distanceKm,
        );
        context.push(AppRouter.farmerDetail, extra: fullFarmer);
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kPillGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AppCachedImage(
                    imageUrl:
                        farmer.profileImage ?? AppConstants.placeholderImage,
                    width: 52,
                    height: 52,
                  ),
                ),
                if (farmer.isVerified == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: kFreshGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.verified,
                          size: 8, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              farmer.name,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: kDarkGreen,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '${farmer.distanceKm?.toStringAsFixed(1) ?? '?'} km',
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreOrderCard(HomePreOrders harvest) {
    final daysUntil = harvest.daysUntilHarvest ??
        (harvest.harvestDate != null
            ? harvest.harvestDate!.difference(DateTime.now()).inDays
            : 0);
    final totalQty = harvest.targetAmount ?? harvest.stockQuantity ?? 0;
    final currentBooked = harvest.currentBooked ?? 0;
    final availableQty = totalQty - currentBooked;
    final preOrderPct =
        totalQty > 0 ? (currentBooked / totalQty * 100).clamp(0.0, 100.0) : 0.0;

    return GestureDetector(
      onTap: () {
        if (harvest.slug != null && harvest.slug!.isNotEmpty) {
          context.push('${AppRouter.products}/${harvest.slug}');
        }
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
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AppCachedImage(
                    imageUrl: harvest.image ?? AppConstants.placeholderImage,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // Countdown badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: daysUntil <= 1 ? kAccentOrange : kDarkGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(
                          harvest.countdownLabel ??
                              (daysUntil == 0
                                  ? 'Today!'
                                  : daysUntil == 1
                                      ? 'Tomorrow'
                                      : '$daysUntil days'),
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                if (harvest.isOrganic == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Text('🌿', style: TextStyle(fontSize: 11)),
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
                    harvest.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kDarkGreen),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    harvest.farmer?.name ?? 'Unknown Farmer',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${preOrderPct.toStringAsFixed(0)}% booked',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: Colors.grey[500]),
                      ),
                      Text(
                        '$availableQty ${harvest.unit ?? 'kg'} left',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              availableQty < 20 ? kAccentOrange : kFreshGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: preOrderPct / 100,
                      minHeight: 5,
                      backgroundColor: kPillGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        preOrderPct > 70 ? kAccentOrange : kFreshGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(harvest.price ?? 0),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kDarkGreen,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPreOrderBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Pre-Order',
                          style: GoogleFonts.inter(
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

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => context.push('${AppRouter.products}/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPillGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                    errorAssetImage: AppConstants.placeholderImage,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border,
                        size: 15, color: Colors.grey),
                  ),
                ),
                // Fresh badge
                if (product.isPerishable)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: kFreshGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'FRESH',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.seller,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(product.price),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kDarkGreen,
                        ),
                      ),
                      if (product.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 12, color: kAccentOrange),
                            const SizedBox(width: 2),
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kAccentOrange,
                              ),
                            ),
                          ],
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
}

// ─── Custom Painters ─────────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC4D5C8)
      ..style = PaintingStyle.fill;
    const step = 22.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        if ((x + y).toInt() % 3 == 0) {
          canvas.drawCircle(Offset(x, y), 1.2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8D0BE).withOpacity(0.8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.4,
          size.width * 0.75, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.45);

    final path2 = Path()
      ..moveTo(size.width * 0.3, 0)
      ..quadraticBezierTo(
          size.width * 0.4, size.height * 0.4, size.width * 0.5, size.height);

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint..strokeWidth = 6);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
