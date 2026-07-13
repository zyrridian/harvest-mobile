import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/catalog/domain/entities/product_detail.dart';
import '../../../../features/sales/presentation/providers/cart/cart_controller.dart';
import '../providers/product_detail_controller.dart';

extension ProductDetailUIExtensions on ProductDetail {
  bool get isInStock => stockQuantity > 0;
  double get finalPrice => discount != null ? price - discount! : price;
  String get url => '';
  bool get hasDiscount => discount != null && discount! > 0;
  double get savings => discount ?? 0;
}

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kCream = Color(0xFFF0EAD6);
const kAccentOrange = kDarkGreen;
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);
const kFreshGreen = Color(0xFF10B981);
const kPreOrderBlue = Color(0xFF3B82F6);

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Track product view when screen loads
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // ref.read(trackProductViewUseCaseProvider).call(widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailControllerProvider(widget.slug));

    return Scaffold(
      backgroundColor: kBgColor,
      body: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 350, color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 32, width: 250, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 20, width: 150, color: Colors.white),
                    const SizedBox(height: 24),
                    Container(height: 80, width: double.infinity, color: Colors.white, margin: const EdgeInsets.only(bottom: 16)),
                    Container(height: 80, width: double.infinity, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
        data: (product, isFavorite, quantity, isInCart) =>
            _buildProductDetail(context, product),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(PhosphorIconsRegular.warningCircle,
                  size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(productDetailControllerProvider(widget.slug).notifier)
                    .refresh(),
                style: ElevatedButton.styleFrom(backgroundColor: kDarkGreen),
                child: Text('Retry',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: state.maybeWhen(
        data: (product, _, __, ___) => _buildBottomBar(context, product),
        orElse: () => null,
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductDetail product) {
    return RefreshIndicator(
      onRefresh: () => ref
          .read(productDetailControllerProvider(widget.slug).notifier)
          .refresh(),
      color: kDarkGreen,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context, product),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildProductHeader(context, product),
                  const SizedBox(height: 16),
                  _buildPriceSection(context, product),
                  if (product.isHarvest) ...[
                    const SizedBox(height: 16),
                    _buildPreOrderSection(context, product),
                  ],
                  const SizedBox(height: 16),
                  _buildLabels(context, product),
                  const SizedBox(height: 16),
                  _buildSellerInfo(context, product),
                  const SizedBox(height: 16),
                  _buildDescription(context, product),
                  const SizedBox(height: 16),
                  _buildRatingReviews(context, product),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Pre-Order Section Widget
  Widget _buildPreOrderSection(BuildContext context, ProductDetail product) {
    final daysUntil = product.harvestDate != null
        ? product.harvestDate!.difference(DateTime.now()).inDays
        : 0;
    final target = product.targetAmount ?? 0;
    final progress =
        target > 0 ? (product.currentBooked / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPreOrderBlue.withOpacity(0.1),
            kPreOrderBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with countdown
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPreOrderBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  PhosphorIconsRegular.calendarCheck,
                  color: kPreOrderBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harvest Pre-Order',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kDarkGreen,
                          ),
                    ),
                    if (product.harvestDate != null)
                      Text(
                        'Harvest on ${DateFormat('EEEE, MMM d').format(product.harvestDate!)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: kTextGrey,
                            ),
                      ),
                  ],
                ),
              ),
              if (product.harvestDate != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: daysUntil <= 1 ? kAccentOrange : kPreOrderBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(PhosphorIconsRegular.clock,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        daysUntil <= 0
                            ? 'Today!'
                            : daysUntil == 1
                                ? 'Tomorrow'
                                : '$daysUntil days',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.currentBooked.toStringAsFixed(0)} ${product.unit} booked',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: kTextGrey,
                        ),
                  ),
                  Text(
                    target > 0
                        ? '${target.toStringAsFixed(0)} ${product.unit} target'
                        : 'Available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: progress >= 0.9 ? kAccentOrange : kDarkGreen,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: kPillGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 0.7 ? kAccentOrange : kPreOrderBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ProductDetail product) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: kBgColor,
      surfaceTintColor: kBgColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: IconButton(
            icon: const Icon(PhosphorIconsRegular.caretLeft,
                color: kDarkGreen, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Consumer(
            builder: (context, ref, child) {
              final state =
                  ref.watch(productDetailControllerProvider(widget.slug));
              final isFavorite = state.maybeWhen(
                data: (_, fav, __, ___) => fav,
                orElse: () => false,
              );
              return CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(
                      isFavorite
                          ? PhosphorIconsFill.heart
                          : PhosphorIconsRegular.heart,
                      size: 20),
                  color: isFavorite ? Colors.red : kDarkGreen,
                  onPressed: () => ref
                      .read(
                          productDetailControllerProvider(widget.slug).notifier)
                      .toggleFavorite(),
                  padding: EdgeInsets.zero,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.shareNetwork,
                  color: kDarkGreen, size: 20),
              onPressed: () => _shareProduct(product),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.shoppingCart,
                  color: kDarkGreen, size: 20),
              onPressed: () => context.push('/cart'),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: product.images.length,
              onPageChanged: (index) =>
                  setState(() => _currentImageIndex = index),
              itemBuilder: (context, index) {
                return Image.network(
                  product.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(PhosphorIconsRegular.imageBroken,
                          size: 64),
                    );
                  },
                );
              },
            ),
            // Pagination Dots
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? kDarkGreen
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            if (product.hasDiscount)
              Positioned(
                top: 100,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kAccentOrange,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '-${((product.savings / product.price) * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: kDarkGreen,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(PhosphorIconsFill.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              product.rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              '${product.reviewCount} Reviews',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: kTextGrey, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${NumberFormat('#,###').format(product.reviewCount * 3)} sold',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: kTextGrey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, ProductDetail product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kAccentOrange.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(color: kPillGrey),
          bottom: BorderSide(color: kPillGrey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.hasDiscount) ...[
            Text(
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                  .format(product.price),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: kTextGrey,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(product.finalPrice),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${product.unit}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kTextGrey, fontSize: 16),
              ),
            ],
          ),
          if (product.hasDiscount && product.savings > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Save ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.savings)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kFreshGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabels(BuildContext context, ProductDetail product) {
    final labels = <Widget>[];

    for (var tag in product.tags) {
      labels.add(_buildLabelChip(tag, kAccentOrange));
    }

    if (labels.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: labels,
      ),
    );
  }

  Widget _buildLabelChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kAccentOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: kAccentOrange,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
      ),
    );
  }

  Widget _buildSellerInfo(BuildContext context, ProductDetail product) {
    final farmer = product.farmer;
    final sellerName = product.sellerName;
    final sellerId = product.sellerId;
    final profileImage = farmer.profileImage;
    final isVerified = farmer.isVerified;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kPillGrey),
        boxShadow: [
          BoxShadow(
            color: kDarkGreen.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                profileImage != null ? NetworkImage(profileImage) : null,
            child: profileImage == null
                ? Text(sellerName.isNotEmpty ? sellerName[0] : '?')
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(sellerName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: kDarkGreen)),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(PhosphorIconsFill.checkCircle,
                          size: 16, color: Colors.blue),
                    ],
                  ],
                ),
                Text(
                  'Local Farmer',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _viewSellerProfile(sellerId),
            style: OutlinedButton.styleFrom(
              foregroundColor: kDarkGreen,
              side: const BorderSide(color: kPillGrey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              minimumSize: const Size(80, 36),
            ),
            child: Text('Visit',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: kTextGrey,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildRatingReviews(BuildContext context, ProductDetail product) {
    if (product.reviewCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ratings & Reviews',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
              ),
              TextButton(
                onPressed: () => _viewAllReviews(product),
                child: Text('View All',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: kAccentOrange)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                product.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < product.rating.floor()
                              ? PhosphorIconsFill.star
                              : PhosphorIconsRegular.star,
                          color: kAccentOrange,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Based on ${product.reviewCount} reviews',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: kTextGrey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetail product) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: kDarkGreen.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildRegularBottomBar(context, product),
      ),
    );
  }

  // Regular purchase bottom bar
  Widget _buildRegularBottomBar(BuildContext context, ProductDetail product) {
    return Row(
      children: [
        // 1. Quantity Selector
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kPillGrey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(PhosphorIconsRegular.minus, size: 20),
                color: kDarkGreen,
                onPressed: () => _decrementQuantity(product),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final state =
                      ref.watch(productDetailControllerProvider(widget.slug));
                  final quantity = state.maybeWhen(
                    data: (_, __, q, ___) => q,
                    orElse: () => 1,
                  );
                  return Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkGreen),
                  );
                },
              ),
              IconButton(
                icon: const Icon(PhosphorIconsRegular.plus, size: 20),
                color: kDarkGreen,
                onPressed: () => _incrementQuantity(product),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // 2. Add to Cart Button
        ElevatedButton(
          onPressed: product.isInStock ? () => _addToCart(product) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentOrange,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(54, 54),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Icon(PhosphorIconsRegular.shoppingCart,
              color: Colors.white, size: 22),
        ),

        const SizedBox(width: 12),

        // 3. Buy Now Button
        Expanded(
          child: ElevatedButton(
            onPressed: product.isInStock ? () => _buyNow(product) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(product.isHarvest ? 'Pre-Order Now' : 'Buy Now',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _incrementQuantity(ProductDetail product) {
    ref
        .read(productDetailControllerProvider(widget.slug).notifier)
        .incrementQuantity();
  }

  void _decrementQuantity(ProductDetail product) {
    ref
        .read(productDetailControllerProvider(widget.slug).notifier)
        .decrementQuantity();
  }

  void _addToCart(ProductDetail product) {
    final state = ref.read(productDetailControllerProvider(widget.slug));
    final quantity = state.maybeWhen(
      data: (_, __, q, ___) => q,
      orElse: () => 1,
    );
    _showSnackBar('Added $quantity ${product.unit} to cart');
    ref.read(productDetailControllerProvider(widget.slug).notifier).addToCart();
    
    // Add to actual global cart
    ref.read(cartControllerProvider.notifier).addItem(product.id, quantity);

    // Do not navigate to cart immediately, user can click cart icon instead
  }

  void _buyNow(ProductDetail product) {
    final state = ref.read(productDetailControllerProvider(widget.slug));
    final quantity = state.maybeWhen(
      data: (_, __, q, ___) => q,
      orElse: () => 1,
    );
    _showSnackBar('Proceeding to checkout with $quantity ${product.unit}');

    // Add to actual global cart
    ref.read(cartControllerProvider.notifier).addItem(product.id, quantity);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.push('/checkout');
      }
    });
  }

  void _shareProduct(ProductDetail product) {
    _showSnackBar('Share product: ${product.name}');
  }

  void _viewSellerProfile(String sellerId) {
    context.push('/farmer-detail', extra: sellerId);
  }

  void _viewAllReviews(ProductDetail product) {
    _showSnackBar('View all ${product.reviewCount} reviews');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
