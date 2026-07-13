import 'package:flutter/material.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_controller.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/features/storefront/presentation/widgets/marketplace_filter_sheet.dart';
import 'package:harvest_app/presentation/shared_widgets/marketplace_product_card.dart';
import 'package:harvest_app/presentation/shared_widgets/app_search_bar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

Widget _buildImage(String imageUrl,
    {double? width, double? height, BoxFit fit = BoxFit.cover}) {
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
      return PhosphorIcon(PhosphorIconsRegular.imageBroken,
          color: Colors.grey, size: width ?? 48);
    }
  } else if (imageUrl.startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const Center(
          child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2))),
      errorWidget: (context, url, error) => PhosphorIcon(
          PhosphorIconsRegular.imageBroken,
          color: Colors.grey,
          size: width ?? 48),
    );
  } else {
    return PhosphorIcon(PhosphorIconsRegular.image,
        color: Colors.grey, size: width ?? 48);
  }
}

const kBgColor = Color(0xFFFFFFFF);
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
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: kDarkGreen),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        titleSpacing: 0,
        title: AppSearchBar(
          hintText: 'Search produce...',
          onSubmitted: (value) => ref
              .read(marketplaceControllerProvider.notifier)
              .searchProducts(value),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 20.0),
            child: GestureDetector(
              onTap: () => context.push('/cart'),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const PhosphorIcon(PhosphorIconsRegular.shoppingBag,
                        color: kDarkGreen),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A8B28),
                          shape: BoxShape.circle,
                          border: Border.all(color: kBgColor, width: 2),
                        ),
                        child: Text(
                          cartItemCount.toString(),
                          style: TextStyle(
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
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () => _buildFullShimmer(),
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
                    // Search moved to AppBar

                    // Flash Harvest Banner
                    if (data.flashHarvest != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2D4A3E), Color(0xFF1A2F25)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1A2F25).withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'FLASH HARVEST',
                                      style: TextStyle(
                                        color: Color(0xFF8CD867),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data.flashHarvest!.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${data.flashHarvest!.subtitle} · ${data.flashHarvest!.distance}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Order now',
                                        style: TextStyle(
                                          color: Color(0xFF1A2F25),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: _buildImage(
                                        data.flashHarvest!.imageUrl,
                                        width: 88,
                                        height: 88,
                                        fit: BoxFit.cover,
                                      ),
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
                              style: TextStyle(
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
                                          child: _buildCategoryItem(
                                              cat, context, ref),
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
                                  'All Products',
                                  style: TextStyle(
                                    color: kDarkGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '· ${data.products.length} items',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: MarketplaceFilterSheet(
                                      initialParams: data.filterParams,
                                      onApply: (params) {
                                        ref
                                            .read(marketplaceControllerProvider
                                                .notifier)
                                            .selectFilter(params);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey[200]!, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Filter & Sort',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black87),
                                    ),
                                    const SizedBox(width: 4),
                                    const PhosphorIcon(
                                        PhosphorIconsRegular.faders,
                                        size: 16,
                                        color: Colors.black87),
                                  ],
                                ),
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
                      sliver: data.isRefetching
                          ? _buildShimmerGrid()
                          : SliverGrid(
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
                                  return MarketplaceProductCard(
                                    product: data.products[index],
                                  );
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
                    child: Material(
                      color: const Color(0xFF2D4A3E),
                      borderRadius: BorderRadius.circular(30),
                      elevation: 8,
                      shadowColor: const Color(0xFF1A2F25).withOpacity(0.4),
                      child: InkWell(
                        onTap: () => context.push('/cart'),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Text(
                                '${data.cartItemCount} items',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'View cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(data.cartTotal)
                                    .replaceAll(',00', ''),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Color(0xFF8CD867),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildCategoryItem(
      MarketplaceCategory category, BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push('/category/${category.id}', extra: category);
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: PhosphorIcon(
                _getCategoryIcon(category.name),
                size: 24,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'vegetables':
        return PhosphorIconsRegular.leaf;
      case 'fruits':
        return PhosphorIconsRegular.appleLogo;
      case 'meat':
        return PhosphorIconsRegular.cow;
      case 'fish':
        return PhosphorIconsRegular.fishSimple;
      case 'dairy':
        return PhosphorIconsRegular.drop;
      case 'eggs':
        return PhosphorIconsRegular.egg;
      case 'grains':
        return PhosphorIconsRegular.plant;
      default:
        return PhosphorIconsRegular.basket;
    }
  }

  Widget _buildFullShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
            ),
          ),
          const SizedBox(height: 24),
          // Categories Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(width: 120, height: 14, color: Colors.white),
          ),
          const SizedBox(height: 16),
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  5,
                  (index) => Column(
                        children: [
                          Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle)),
                          const SizedBox(height: 8),
                          Container(width: 40, height: 12, color: Colors.white),
                        ],
                      )),
            ),
          ),
          const SizedBox(height: 24),
          // Header "All Products"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 140, height: 24, color: Colors.white),
                Container(
                    width: 90,
                    height: 32,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Products Grid
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: _buildShimmerGrid(isSliver: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid({bool isSliver = true}) {
    final grid = SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 60, height: 12, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.white),
                          const SizedBox(height: 4),
                          Container(width: 80, height: 12, color: Colors.white),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 70, height: 16, color: Colors.white),
                              Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white)),
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
        },
        childCount: 4,
      ),
    );
    return isSliver ? grid : CustomScrollView(slivers: [grid]);
  }
}
