import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/presentation/features/marketplace/providers/marketplace_controller.dart';
import 'package:harvest_app/presentation/features/marketplace/providers/marketplace_state.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

Widget _buildImage(String imageUrl, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  if (imageUrl.startsWith('data:image')) {
    try {
      final base64String = imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64String),
        width: width,
        height: height,
        fit: fit,
      );
    } catch (e) {
      return Icon(Icons.broken_image, color: Colors.grey, size: width ?? 48);
    }
  } else if (imageUrl.startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      errorWidget: (context, url, error) => Icon(Icons.broken_image, color: Colors.grey, size: width ?? 48),
    );
  } else {
    return Icon(Icons.image, color: Colors.grey, size: width ?? 48);
  }
}

const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceControllerProvider);

    final int cartItemCount = state.maybeWhen(
      data: (data) => data.cartItemCount,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Icon(Icons.chevron_left, color: kDarkGreen),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: Text(
          'Marketplace',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: kDarkGreen),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: 8,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5A8B28),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartItemCount.toString(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(marketplaceControllerProvider);
            },
            color: kDarkGreen,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search produce, farmers...',
                                    hintStyle: GoogleFonts.inter(
                                        color: Colors.grey, fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: GoogleFonts.inter(
                                      color: Colors.black87, fontSize: 14),
                                  onSubmitted: (value) {
                                    ref.read(marketplaceControllerProvider.notifier).searchProducts(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                      left:
                                          BorderSide(color: Colors.grey[200]!)),
                                ),
                                child:
                                    const Icon(Icons.tune, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    // Filter Chips
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildFilterChip('All',
                                isSelected: data.selectedFilter == 'All',
                                ref: ref),
                            const SizedBox(width: 8),
                            _buildFilterChip('Nearest',
                                isSelected: data.selectedFilter == 'Nearest',
                                ref: ref),
                            const SizedBox(width: 8),
                            _buildFilterChip('Best Rated',
                                isSelected: data.selectedFilter == 'Best Rated',
                                ref: ref),
                            const SizedBox(width: 8),
                            _buildFilterChip('Harvest Today',
                                isSelected:
                                    data.selectedFilter == 'Harvest Today',
                                ref: ref),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    // Flash Harvest Banner
                    if (data.flashHarvest != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF28482A), // Dark green background
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FLASH HARVEST',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF8CD867),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data.flashHarvest!.title,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${data.flashHarvest!.subtitle} · ${data.flashHarvest!.distance}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E3A20),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Order now',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _buildImage(
                                      data.flashHarvest!.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    // Shop by Category
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SHOP BY CATEGORY',
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: data.categories
                                    .map((cat) => Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: _buildCategoryItem(cat),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    // Fresh Today Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Fresh Today',
                                  style: GoogleFonts.inter(
                                    color: kDarkGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '· 48 items',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Sort by',
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.expand_more,
                                      size: 16, color: Colors.black87),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    // Products Grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.65, // Adjust to fit content based on image
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildProductCard(
                                data.products[index], context, ref);
                          },
                          childCount: data.products.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                            height: 100)), // Bottom padding for cart button
                  ],
                ),
                // Floating Cart Bar
                if (data.cartItemCount > 0)
                  Positioned(
                    bottom: 24,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF28482A),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${data.cartItemCount} items',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'View cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(data.cartTotal)
                                  .replaceAll(',00', '')
                                  .replaceFirst('Rp ', 'Rp\n'),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: const Color(
                                    0xFFD4A373), // A golden-like color based on the design
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label,
      {bool isSelected = false, required WidgetRef ref}) {
    return GestureDetector(
      onTap: () {
        ref.read(marketplaceControllerProvider.notifier).selectFilter(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF28482A) : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(MarketplaceCategory category) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(category.gradientColors.first).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              category.iconPath,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
      MarketplaceProduct product, BuildContext context, WidgetRef ref) {
    Color bgColor = Colors.grey[100]!;
    if (product.name.contains('Bayam')) bgColor = const Color(0xFFE8F3E8);
    if (product.name.contains('Strawberry')) bgColor = const Color(0xFFFDE8F1);
    if (product.name.contains('Ikan')) bgColor = const Color(0xFFE3F2FD);
    if (product.name.contains('Wortel')) bgColor = const Color(0xFFFFF3E0);

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing ${product.name}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Top Area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: _buildImage(
                        product.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (product.isFresh)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28482A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'FRESH',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Icon(Icons.favorite_border,
                          size: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            // Details Area
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} · ${product.soldCount} sold',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.farmerName,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatter
                                    .format(product.price)
                                    .replaceAll(',00', ''),
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF28482A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: ' /${product.unit}',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(marketplaceControllerProvider.notifier)
                              .addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add,
                              size: 14, color: Colors.black87),
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
}
