import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../features/catalog/domain/entities/product_detail.dart';
import '../providers/product_detail_controller.dart';
import '../providers/product_detail_state.dart';

extension ProductDetailUIExtensions on ProductDetail {
  bool get isInStock => stockQuantity > 0;
  double get finalPrice => discount != null ? price - discount! : price;
  String get url => '';
  bool get hasDiscount => discount != null && discount! > 0;
  double get savings => discount ?? 0;
}

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
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
        loading: () => const Center(
          child: CircularProgressIndicator(color: kDarkGreen),
        ),
        data: (product, isFavorite, quantity, isInCart) => _buildProductDetail(context, product),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(productDetailControllerProvider(widget.slug).notifier).refresh(),
                style: ElevatedButton.styleFrom(backgroundColor: kDarkGreen),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
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
    return CustomScrollView(
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
    );
  }

  // NEW: Pre-Order Section Widget
  Widget _buildPreOrderSection(BuildContext context, ProductDetail product) {
    final daysUntil = product.harvestDate != null 
        ? product.harvestDate!.difference(DateTime.now()).inDays
        : 0;
    final target = product.targetAmount ?? 0;
    final progress = target > 0 ? (product.currentBooked / target).clamp(0.0, 1.0) : 0.0;

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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPreOrderBlue.withOpacity(0.3)),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_available,
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
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkGreen,
                      ),
                    ),
                    if (product.harvestDate != null)
                      Text(
                        'Harvest on ${DateFormat('EEEE, MMM d').format(product.harvestDate!)}',
                        style: GoogleFonts.inter(
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
                      const Icon(Icons.schedule, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        daysUntil <= 0
                            ? 'Today!'
                            : daysUntil == 1
                                ? 'Tomorrow'
                                : '$daysUntil days',
                        style: GoogleFonts.inter(
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
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                  Text(
                    target > 0 ? '${target.toStringAsFixed(0)} ${product.unit} target' : 'Available',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: progress >= 0.9
                          ? kAccentOrange
                          : kDarkGreen,
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
                    progress >= 0.7
                        ? kAccentOrange
                        : kPreOrderBlue,
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
            icon: const Icon(Icons.arrow_back, color: kDarkGreen, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(productDetailControllerProvider(widget.slug));
                final isFavorite = state.maybeWhen(
                  data: (_, fav, __, ___) => fav,
                  orElse: () => false,
                );
                return IconButton(
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20),
                  color: isFavorite ? kAccentOrange : kDarkGreen,
                  onPressed: () => ref.read(productDetailControllerProvider(widget.slug).notifier).toggleFavorite(),
                  padding: EdgeInsets.zero,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(Icons.share, color: kDarkGreen, size: 20),
              onPressed: () => _shareProduct(product),
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
                      child: const Icon(Icons.broken_image, size: 64),
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '-${((product.savings / product.price) * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.inter(
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
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              product.rating.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${product.reviewCount} Reviews',
              style: GoogleFonts.inter(color: kTextGrey, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${NumberFormat('#,###').format(product.reviewCount * 3)} sold',
              style: GoogleFonts.inter(color: kTextGrey, fontSize: 14),
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
              style: GoogleFonts.inter(
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
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${product.unit}',
                style: GoogleFonts.inter(color: kTextGrey, fontSize: 16),
              ),
            ],
          ),
          if (product.hasDiscount && product.savings > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Save ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.savings)}',
              style: GoogleFonts.inter(
                color: const Color(0xFF10B981),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccentOrange.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
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
        borderRadius: BorderRadius.circular(20),
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
            backgroundImage: profileImage != null
                ? NetworkImage(profileImage)
                : null,
            child: profileImage == null ? Text(sellerName.isNotEmpty ? sellerName[0] : '?') : null,
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
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kDarkGreen)),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 16, color: Colors.blue),
                    ],
                  ],
                ),
                Text(
                  'Local Farmer',
                  style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
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
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              minimumSize: const Size(80, 36),
            ),
            child: Text('Visit',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: GoogleFonts.inter(
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
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              TextButton(
                onPressed: () => _viewAllReviews(product),
                child: Text('View All',
                    style: GoogleFonts.inter(color: kAccentOrange)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                product.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(
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
                              ? Icons.star
                              : Icons.star_border,
                          color: kAccentOrange,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Based on ${product.reviewCount} reviews',
                        style: GoogleFonts.inter(color: kTextGrey)),
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20),
                color: kDarkGreen,
                onPressed: () => _decrementQuantity(product),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(productDetailControllerProvider(widget.slug));
                  final quantity = state.maybeWhen(
                    data: (_, __, q, ___) => q,
                    orElse: () => 1,
                  );
                  return Text(
                    '$quantity',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkGreen),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Icon(Icons.shopping_cart_outlined,
              color: Colors.white, size: 22),
        ),

        const SizedBox(width: 12),

        // 3. Buy Now Button
        Expanded(
          child: ElevatedButton(
            onPressed: product.isInStock ? () => _buyNow(product) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(product.isHarvest ? 'Pre-Order Now' : 'Buy Now',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void _incrementQuantity(ProductDetail product) {
    ref.read(productDetailControllerProvider(widget.slug).notifier).incrementQuantity();
  }

  void _decrementQuantity(ProductDetail product) {
    ref.read(productDetailControllerProvider(widget.slug).notifier).decrementQuantity();
  }

  void _addToCart(ProductDetail product) {
    final state = ref.read(productDetailControllerProvider(widget.slug));
    final quantity = state.maybeWhen(
      data: (_, __, q, ___) => q,
      orElse: () => 1,
    );
    _showSnackBar('Added $quantity ${product.unit} to cart');
    ref.read(productDetailControllerProvider(widget.slug).notifier).addToCart();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushNamed(context, '/cart');
      }
    });
  }

  void _buyNow(ProductDetail product) {
    final state = ref.read(productDetailControllerProvider(widget.slug));
    final quantity = state.maybeWhen(
      data: (_, __, q, ___) => q,
      orElse: () => 1,
    );
    _showSnackBar('Proceeding to checkout with $quantity ${product.unit}');

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushNamed(context, '/checkout');
      }
    });
  }

  void _shareProduct(ProductDetail product) {
    _showSnackBar('Share product: ${product.name}');
  }

  void _viewSellerProfile(String sellerId) {
    _showSnackBar('View seller profile: $sellerId');
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
