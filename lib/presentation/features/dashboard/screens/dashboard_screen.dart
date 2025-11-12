import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/presentation/features/search/screens/search_screen.dart';
import 'package:harvest_app/presentation/features/category/screens/category_screen.dart';
import 'package:harvest_app/presentation/shared_widgets/app_cached_image.dart';
import '../../../../core/config/theme/app_colors.dart';

// Mock data models
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.backgroundColor,
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

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<Category> categories = [
    Category(
      id: 'vegetables',
      name: 'Vegetables',
      icon: Icons.eco,
      color: const Color(0xFF22C55E),
      backgroundColor: const Color(0xFFDCFCE7),
    ),
    Category(
      id: 'fruits',
      name: 'Fruits',
      icon: Icons.apple,
      color: const Color(0xFFEF4444),
      backgroundColor: const Color(0xFFFEE2E2),
    ),
    Category(
      id: 'meat',
      name: 'Meat',
      icon: Icons.restaurant,
      color: const Color(0xFFDC2626),
      backgroundColor: const Color(0xFFFEE2E2),
    ),
    Category(
      id: 'fish',
      name: 'Fish',
      icon: Icons.set_meal,
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFFDBEAFE),
    ),
    Category(
      id: 'dairy',
      name: 'Dairy',
      icon: Icons.local_drink,
      color: const Color(0xFFF59E0B),
      backgroundColor: const Color(0xFFFEF3C7),
    ),
    Category(
      id: 'eggs',
      name: 'Eggs',
      icon: Icons.egg_outlined,
      color: const Color(0xFFFBBF24),
      backgroundColor: const Color(0xFFFEF9C3),
    ),
    Category(
      id: 'grains',
      name: 'Grains',
      icon: Icons.grass,
      color: const Color(0xFF8B5CF6),
      backgroundColor: const Color(0xFFEDE9FE),
    ),
    Category(
      id: 'more',
      name: 'More',
      icon: Icons.grid_view_rounded,
      color: const Color(0xFF6B7280),
      backgroundColor: const Color(0xFFF3F4F6),
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

  final List<Product> premiumProducts = [
    Product(
      name: 'Organic Tomatoes',
      seller: 'Green Valley Farm',
      price: 4.99,
      unit: 'kg',
      imageUrl:
          'https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=400',
      isPremium: true,
      rating: 4.8,
    ),
    Product(
      name: 'Fresh Strawberries',
      seller: 'Sunrise Organic',
      price: 8.99,
      unit: 'box',
      imageUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      isPremium: true,
      rating: 4.9,
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Cart and Notifications
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            centerTitle: false,
            titleSpacing: 20.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harvest Market',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                Text(
                  'Fresh from local farms',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            actions: [
              // Notifications
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: AppColors.textPrimary),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  context.push(AppRouter.notifications);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Notifications coming soon')),
                  // );
                },
              ),
              // Cart
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  context.push(AppRouter.cart);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: Colors.grey[600], size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search fresh products...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // // Demo Quick Actions: Cart & Orders
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: ElevatedButton.icon(
          //             onPressed: () {
          //               context.push(AppRouter.cart);
          //             },
          //             icon: const Icon(Icons.shopping_cart_outlined),
          //             label: const Text('Cart'),
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: AppColors.primary,
          //               foregroundColor: Colors.white,
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 12),
          //         Expanded(
          //           child: ElevatedButton.icon(
          //             onPressed: () {
          //               context.push(AppRouter.orders);
          //             },
          //             icon: const Icon(Icons.list_alt_outlined),
          //             label: const Text('My Orders'),
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: AppColors.secondary,
          //               foregroundColor: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Categories Section - Modern Grid Design
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Categories',
                  //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20,
                  //           ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const CategoryScreen(
                  //               categoryName: 'All Categories',
                  //               categoryId: 'all',
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       child: const Text('See All'),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _buildModernCategoryCard(categories[index]);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Near Me Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Near Me',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: nearbyFarmers.length,
                    itemBuilder: (context, index) {
                      return _buildFarmerCard(nearbyFarmers[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Premium Products Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stars,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Premium Products',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: premiumProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(premiumProducts[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Fresh Today Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_shipping,
                          color: AppColors.success, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Fresh Today',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),

          // Fresh Today Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildGridProductCard(freshToday[index]);
                },
                childCount: freshToday.length,
              ),
            ),
          ),

          // Seasonal Recommendations
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    'Seasonal Picks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=200',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Winter Collection',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get the best seasonal produce',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Explore now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(
              categoryName: category.name,
              categoryId: category.id,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCard(FarmerProfile farmer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('View ${farmer.name} profile')),
          );
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    farmer.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        farmer.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        farmer.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 2),
                          Text(
                            '${farmer.distance} km',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            farmer.rating.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          context.push(
              '${AppRouter.productDetail}?productId=prd_1234567890abcdef');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('View ${product.name} details')),
          // );
        },
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AppCachedImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (product.isPremium)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Premium',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: AppColors.textSecondary,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.seller,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price}/${product.unit}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (product.rating != null)
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                product.rating.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
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
      ),
    );
  }

  Widget _buildGridProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View ${product.name} details')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.seller,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product.price}/${product.unit}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (product.rating != null)
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                product.rating.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
