import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_product.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/pill_tab_bar.dart';
import '../providers/farmer_products_controller.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kBorderColor = Color(0xFFE5E7EB);
const kTextGrey = Color(0xFF6E7A75);

class FarmerProductScreen extends ConsumerStatefulWidget {
  const FarmerProductScreen({super.key});

  @override
  ConsumerState<FarmerProductScreen> createState() =>
      _FarmerProductScreenState();
}

class _FarmerProductScreenState extends ConsumerState<FarmerProductScreen> {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _filters = [
    {'name': 'All', 'value': 'all', 'icon': null},
    {'name': 'Active', 'value': 'active', 'icon': null},
    {'name': 'Inactive', 'value': 'inactive', 'icon': null},
    {'name': 'Out of Stock', 'value': 'out_of_stock', 'icon': null},
  ];
  int _selectedFilterIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(farmerProductsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                backgroundColor: kBgColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                      color: kDarkGreen),
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                ),
                title: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: _isSearchVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  layoutBuilder:
                      (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          key: bottomChildKey,
                          left: 0.0,
                          right: 0.0,
                          child: bottomChild,
                        ),
                        Positioned(
                          key: topChildKey,
                          child: topChild,
                        ),
                      ],
                    );
                  },
                  firstChild: const SizedBox(
                    child: Text(
                      'My Products',
                      style: TextStyle(
                        color: kDarkGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: AppSearchBar(
                      hintText: 'Search products...',
                      height: 38,
                      onChanged: (value) {
                        ref
                            .read(farmerProductsControllerProvider.notifier)
                            .setSearchQuery(value);
                      },
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: PhosphorIcon(
                      _isSearchVisible
                          ? PhosphorIconsRegular.x
                          : PhosphorIconsRegular.magnifyingGlass,
                      color: kDarkGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = !_isSearchVisible;
                        if (!_isSearchVisible) {
                          _searchController.clear();
                          ref
                              .read(farmerProductsControllerProvider.notifier)
                              .setSearchQuery('');
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ];
          },
          body: RefreshIndicator(
            color: kDarkGreen,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await ref
                  .read(farmerProductsControllerProvider.notifier)
                  .refresh();
            },
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PillTabBarDelegate(
                    height: 52.0,
                    child: PillTabBar(
                      backgroundColor: kBgColor,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      tabs: _filters
                          .map((f) => PillTabItem(
                                name: f['name'] as String,
                                icon: f['icon'] as IconData?,
                              ))
                          .toList(),
                      selectedIndex: _selectedFilterIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                        ref
                            .read(farmerProductsControllerProvider.notifier)
                            .setFilter(_filters[index]['value'] as String);
                      },
                    ),
                  ),
                ),
                productsState.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(color: kDarkGreen)),
                  ),
                  error: (error) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(error.toString(),
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(farmerProductsControllerProvider.notifier)
                                .refresh(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (products) {
                    if (products.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text('No products found',
                              style: TextStyle(color: kTextGrey)),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.only(top: 0, bottom: 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return _buildProductCard(context, ref, product);
                          },
                          childCount: products.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addProductFab',
        onPressed: () => context.push(AppRouter.addProduct),
        backgroundColor: kDarkGreen,
        shape: const CircleBorder(),
        child:
            const PhosphorIcon(PhosphorIconsRegular.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, WidgetRef ref, FarmerProduct product) {
    final inStock = product.stock > 0 && product.isAvailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key(product.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const PhosphorIcon(PhosphorIconsRegular.trash,
              color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Product'),
              content:
                  const Text('Are you sure you want to delete this product?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          ref
              .read(farmerProductsControllerProvider.notifier)
              .deleteProduct(product.id);
        },
        child: GestureDetector(
          onTap: () {
            context.push(AppRouter.addProduct, extra: product.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 72,
                    height: 72,
                    foregroundDecoration: !inStock
                        ? BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: AppCachedImage(
                      imageUrl: product.imageUrl,
                      borderRadius: BorderRadius.circular(8),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: inStock ? kDarkGreen : kTextGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${product.stock}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kTextGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)} / ${product.unit}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: inStock
                                ? kDarkGreen
                                : kTextGrey.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stock Toggle & Action
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Switch.adaptive(
                        value: inStock,
                        activeColor: kDarkGreen,
                        onChanged: (value) {
                          ref
                              .read(farmerProductsControllerProvider.notifier)
                              .toggleAvailability(product.id, value);
                        },
                      ),
                      Text(
                        inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 11,
                          color: inStock ? kDarkGreen : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
