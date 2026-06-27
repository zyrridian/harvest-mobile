import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category_providers.dart';

// Design colors
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsAsync =
        ref.watch(categoryProductsProvider(widget.categoryId));
    final sortOption = ref.watch(selectedSortOptionProvider);
    final showOnlyOrganic = ref.watch(showOnlyOrganicProvider);
    final showOnlyPremium = ref.watch(showOnlyPremiumProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
            elevation: 0,
            toolbarHeight: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E5E0)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: kDarkGreen),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Text(
              widget.categoryName,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kDarkGreen,
              ),
            ),
          ),

          // Filter & Sort Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  // Sort & Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterButton(
                          icon: Icons.sort,
                          label: _getSortLabel(sortOption),
                          onTap: () => _showSortOptions(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterButton(
                        icon: Icons.filter_list,
                        label: 'Filter',
                        onTap: () => _showFilterOptions(context),
                        hasBadge: showOnlyOrganic || showOnlyPremium,
                      ),
                    ],
                  ),

                  // Active Filters
                  if (showOnlyOrganic || showOnlyPremium) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (showOnlyOrganic)
                          _buildFilterChip(
                            'Organic',
                            onRemove: () => ref
                                .read(showOnlyOrganicProvider.notifier)
                                .state = false,
                          ),
                        if (showOnlyOrganic && showOnlyPremium)
                          const SizedBox(width: 8),
                        if (showOnlyPremium)
                          _buildFilterChip(
                            'Premium',
                            onRemove: () => ref
                                .read(showOnlyPremiumProvider.notifier)
                                .state = false,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Products Grid
          productsAsync.when(
            data: (products) {
              // Apply filters
              var filteredProducts = products;
              if (showOnlyOrganic) {
                filteredProducts =
                    filteredProducts.where((p) => p.isOrganic).toList();
              }
              if (showOnlyPremium) {
                filteredProducts =
                    filteredProducts.where((p) => p.isPremium).toList();
              }

              // Apply sorting
              filteredProducts = _sortProducts(filteredProducts, sortOption);

              if (filteredProducts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildProductCard(filteredProducts[index]);
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: kDarkGreen),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load products',
                      style: GoogleFonts.inter(fontSize: 16, color: kTextGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.popular:
        return 'Popular';
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortOption.nameAZ:
        return 'Name: A-Z';
      case ProductSortOption.rating:
        return 'Rating';
    }
  }

  List<CategoryProduct> _sortProducts(
    List<CategoryProduct> products,
    ProductSortOption option,
  ) {
    final sorted = List<CategoryProduct>.from(products);
    switch (option) {
      case ProductSortOption.popular:
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case ProductSortOption.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.nameAZ:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.rating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return sorted;
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPillGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 18, color: kDarkGreen),
                if (hasBadge)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: kAccentOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kDarkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kDarkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CategoryProduct product) {
    return GestureDetector(
      onTap: () => context.push('${AppRouter.products}/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPillGrey),
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
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: kPillGrey,
                      child: const Icon(Icons.image, color: kTextGrey),
                    ),
                  ),
                ),
                if (product.discount != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kAccentOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.discount!,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                    child: const Icon(Icons.favorite_border,
                        size: 16, color: kDarkGreen),
                  ),
                ),
                if (product.isOrganic || product.isPremium)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (product.isOrganic)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ORGANIC',
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (product.isOrganic && product.isPremium)
                          const SizedBox(width: 4),
                        if (product.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kDarkGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.sellerName,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: kTextGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreen,
                        ),
                      ),
                      Text(
                        ' (${product.reviewCount})',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: kTextGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kDarkGreen,
                        ),
                      ),
                      Text(
                        product.unit,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: kTextGrey,
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

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 16),
            ...ProductSortOption.values.map((option) {
              final isSelected = ref.read(selectedSortOptionProvider) == option;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _getSortLabel(option),
                  style: GoogleFonts.inter(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? kDarkGreen : kTextGrey,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: kDarkGreen)
                    : null,
                onTap: () {
                  ref.read(selectedSortOptionProvider.notifier).state = option;
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final organic = ref.watch(showOnlyOrganicProvider);
                final premium = ref.watch(showOnlyPremiumProvider);

                return Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Organic Only',
                        style: GoogleFonts.inter(color: kDarkGreen),
                      ),
                      value: organic,
                      activeColor: kDarkGreen,
                      onChanged: (value) {
                        ref.read(showOnlyOrganicProvider.notifier).state =
                            value;
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Premium Only',
                        style: GoogleFonts.inter(color: kDarkGreen),
                      ),
                      value: premium,
                      activeColor: kDarkGreen,
                      onChanged: (value) {
                        ref.read(showOnlyPremiumProvider.notifier).state =
                            value;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
