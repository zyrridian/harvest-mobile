import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to add this package
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/presentation/features/search/screens/search_screen.dart';
import 'package:harvest_app/presentation/features/category/screens/category_screen.dart';
import 'package:harvest_app/presentation/shared_widgets/app_cached_image.dart';
import '../../../../core/config/theme/app_colors.dart';

// --- NEW 2025 DESIGN COLORS ---
const kBgColor = Color(0xFFFAFAF8); // Warm off-white
const kDarkGreen = Color(0xFF1A2F25); // Deep Forest
const kAccentOrange = Color(0xFFE86A33); // Burnt Orange
const kPillGrey = Color(0xFFF0F2F0); // Stone Grey

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
  final String name;
  final String location;
  final double distance;
  final double rating;
  final String imageUrl;

  FarmerProfile({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.imageUrl,
  });
}

class Product {
  final String name;
  final String seller;
  final double price;
  final String unit;
  final String imageUrl;
  final bool isPremium;
  final double? rating;

  Product({
    required this.name,
    required this.seller,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.isPremium = false,
    this.rating,
  });
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<HomeScreen> {
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
  final List<FarmerProfile> nearbyFarmers = [
    FarmerProfile(
      name: 'Green Valley Farm',
      location: 'North District',
      distance: 1.2,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=200',
    ),
    FarmerProfile(
      name: 'Sunrise Organic',
      location: 'East Village',
      distance: 2.5,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200',
    ),
    FarmerProfile(
      name: 'Fresh Fields Co.',
      location: 'West End',
      distance: 3.1,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=200',
    ),
  ];

  final List<Product> freshToday = [
    Product(
      name: 'Fresh Lettuce',
      seller: 'Green Valley Farm',
      price: 2.49,
      unit: 'bunch',
      imageUrl:
          'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
      rating: 4.7,
    ),
    Product(
      name: 'Carrots',
      seller: 'Fresh Fields Co.',
      price: 3.99,
      unit: 'kg',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      rating: 4.6,
    ),
    Product(
      name: 'Bell Peppers',
      seller: 'Sunrise Organic',
      price: 5.49,
      unit: 'kg',
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      rating: 4.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor, // Changed to off-white
      body: CustomScrollView(
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
          // 2. FLAT SEARCH BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
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
                        child: Icon(Icons.tune_rounded,
                            color: kDarkGreen, size: 20),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio:
                          0.72, // Slightly taller to fit long names
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _buildPebbleCategoryCard(categories[index]);
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. NEAR ME (Floating Card Map)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  _buildSectionHeader('Farmers Near You'),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  Container(
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
                itemCount: nearbyFarmers.length,
                itemBuilder: (context, index) {
                  return _buildModernFarmerCard(nearbyFarmers[index]);
                },
              ),
            ),
          ),

          // Fresh Today Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: _buildSectionHeader('Fresh Today', showSeeAll: true),
            ),
          ),

          // Fresh Today Grid (Existing logic, updated font)
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
                  return _buildGridProductCard(freshToday[index]);
                },
                childCount: freshToday.length,
              ),
            ),
          ),

          // REDUCED BOTTOM SPACER
          // Previously 100, now 85. Just enough to clear the 70px nav bar + margins.
          const SliverToBoxAdapter(
            child: SizedBox(height: 85), 
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
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
          Text(
            'See all',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
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

  Widget _buildModernFarmerCard(FarmerProfile farmer) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // More rounded
        border: Border.all(color: const Color(0xFFF0F2F0)), // Subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AppCachedImage(
                imageUrl: farmer.imageUrl,
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    farmer.name,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${farmer.distance}km • ${farmer.location}',
                    style: GoogleFonts.dmSans(
                      color: Colors.grey[500],
                      fontSize: 13,
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

  Widget _buildGridProductCard(Product product) {
    // Keeping your logic, just updating styles
    return Container(
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
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
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
