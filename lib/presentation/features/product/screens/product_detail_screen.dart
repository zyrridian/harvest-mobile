import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/product_detail.dart';
import '../providers/product_detail_controller.dart';
import '../providers/product_detail_state.dart';

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
                // Freshness indicator for perishables
                if (product.isPerishable) ...[
                  _buildFreshnessIndicator(context, product),
                  const SizedBox(height: 12),
                ],
                _buildProductHeader(context, product),
                const SizedBox(height: 16),
                _buildPriceSection(context, product),
                // Pre-order section for upcoming harvests
                if (product.canPreOrder && product.preOrderInfo != null) ...[
                  const SizedBox(height: 16),
                  _buildPreOrderSection(context, product),
                ],
                const SizedBox(height: 16),
                _buildLabels(context, product),
                const SizedBox(height: 16),
                _buildSellerInfo(context, product),
                const SizedBox(height: 16),
                _buildDescription(context, product),
                if (product.specifications != null &&
                    product.specifications!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSpecifications(context, product),
                ],
                if (product.certifications != null &&
                    product.certifications!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildCertifications(context, product),
                ],
                // const SizedBox(height: 16),
                _buildDeliveryOptions(context, product),
                if (product.bulkPricing != null &&
                    product.bulkPricing!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildBulkPricing(context, product),
                ],
                // const SizedBox(height: 16),
                _buildRatingReviews(context, product),
                if (product.relatedProducts != null &&
                    product.relatedProducts!.isNotEmpty) ...[
                  // const SizedBox(height: 16),
                  _buildRelatedProducts(context, product),
                ],
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  // NEW: Freshness Indicator Widget
  Widget _buildFreshnessIndicator(BuildContext context, ProductDetail product) {
    Color freshnessColor;
    String freshnessText;
    IconData freshnessIcon;

    if (product.isJustHarvested) {
      freshnessColor = kFreshGreen;
      freshnessText = '🌱 Just Harvested';
      freshnessIcon = Icons.eco;
    } else if (product.freshnessLevel == FreshnessLevel.fresh) {
      freshnessColor = kFreshGreen;
      freshnessText = '✨ Fresh';
      freshnessIcon = Icons.check_circle;
    } else if (product.freshnessLevel == FreshnessLevel.good) {
      freshnessColor = Colors.amber;
      freshnessText = 'Good Condition';
      freshnessIcon = Icons.thumb_up;
    } else {
      freshnessColor = Colors.grey;
      freshnessText = 'Perishable Item';
      freshnessIcon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: freshnessColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: freshnessColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: freshnessColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(freshnessIcon, color: freshnessColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  freshnessText,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: freshnessColor,
                  ),
                ),
                if (product.harvestDate != null)
                  Text(
                    'Harvested ${_formatHarvestDate(product.harvestDate!)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                if (product.shelfLifeDays != null)
                  Text(
                    'Best within ${product.shelfLifeDays} days',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
              ],
            ),
          ),
          if (product.daysUntilExpiry != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    product.daysUntilExpiry! <= 2 ? kAccentOrange : kFreshGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${product.daysUntilExpiry}d left',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatHarvestDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 1) {
      return 'just now';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  // NEW: Pre-Order Section Widget
  Widget _buildPreOrderSection(BuildContext context, ProductDetail product) {
    final preOrderInfo = product.preOrderInfo!;
    final daysUntil = preOrderInfo.daysUntilHarvest;

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
                      'Pre-Order Available',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkGreen,
                      ),
                    ),
                    Text(
                      'Harvest on ${DateFormat('EEEE, MMM d').format(preOrderInfo.harvestDate)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
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
                      daysUntil == 0
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
                    '${preOrderInfo.preOrderCount} people pre-ordered',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                  Text(
                    '${preOrderInfo.availableQuantity} ${product.unit} available',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: preOrderInfo.isAlmostSoldOut
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
                  value: preOrderInfo.preOrderPercentage / 100,
                  minHeight: 8,
                  backgroundColor: kPillGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    preOrderInfo.preOrderPercentage > 70
                        ? kAccentOrange
                        : kPreOrderBlue,
                  ),
                ),
              ),
            ],
          ),

          // Pre-order benefits
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPreOrderBenefit(Icons.local_shipping, 'Priority Delivery'),
              _buildPreOrderBenefit(Icons.eco, 'Freshest Quality'),
              _buildPreOrderBenefit(Icons.savings, 'Lock-in Price'),
            ],
          ),

          // Deposit info
          if (preOrderInfo.requiresDeposit) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Requires ${preOrderInfo.depositPercentage?.toStringAsFixed(0) ?? '20'}% deposit (${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(preOrderInfo.depositAmount ?? product.price * 0.2)})',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.amber[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreOrderBenefit(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPillGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kPreOrderBlue),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: kDarkGreen,
            ),
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
                  product.images[index].url,
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
                    '-${product.discount!.value.toStringAsFixed(0)}%',
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
              product.rating.average.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.rating.count} reviews)',
              style: GoogleFonts.inter(color: kTextGrey, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${NumberFormat('#,###').format(product.stats.orders)} sold',
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
          if (product.hasDiscount && product.discount!.savings != null) ...[
            const SizedBox(height: 4),
            Text(
              'Save ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.discount!.savings)}',
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

    if (product.labels.isOrganic) {
      labels.add(_buildLabelChip('Organic', Colors.green));
    }
    if (product.labels.isCertified) {
      labels.add(_buildLabelChip('Certified', Colors.blue));
    }
    if (product.labels.isBestSeller) {
      labels.add(_buildLabelChip('Best Seller', Colors.orange));
    }
    if (product.labels.isNew) {
      labels.add(_buildLabelChip('New', Colors.purple));
    }
    if (product.labels.isFeatured) {
      labels.add(_buildLabelChip('Featured', Colors.red));
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
    final seller = product.seller;
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
            backgroundImage: seller.profilePicture != null
                ? NetworkImage(seller.profilePicture!)
                : null,
            child: seller.profilePicture == null ? Text(seller.name[0]) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(seller.name,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kDarkGreen)),
                    if (seller.verified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 16, color: Colors.blue),
                    ],
                  ],
                ),
                Text(
                  '${seller.location.city}, ${seller.location.province}',
                  style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _viewSellerProfile(seller.userId),
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
        if (product.longDescription != null) ...[
          const SizedBox(height: 12),
          Text(
            product.longDescription!,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextGrey,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSpecifications(BuildContext context, ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPillGrey),
          ),
          child: Column(
            children: product.specifications!.map((spec) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        spec.key,
                        style:
                            GoogleFonts.inter(color: kTextGrey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        spec.value,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: kDarkGreen,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCertifications(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Certifications',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          ...product.certifications!.map((cert) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPillGrey, width: 1.5),
              ),
              child: Row(
                children: [
                  if (cert.verified)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.verified,
                          color: Color(0xFF10B981), size: 24),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cert.name,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen)),
                        const SizedBox(height: 4),
                        Text('Issued by: ${cert.issuer}',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: kTextGrey)),
                        Text(
                            'Valid until: ${DateFormat('dd MMM yyyy').format(cert.expiryDate)}',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: kTextGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions(BuildContext context, ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Options',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPillGrey),
          ),
          child: Column(
            children: [
              if (product.deliveryOptions.homeDelivery?.available == true)
                _buildDeliveryOption(
                  icon: Icons.local_shipping,
                  title: 'Home Delivery',
                  subtitle:
                      'Rp ${NumberFormat('#,###').format(product.deliveryOptions.homeDelivery!.fee)} • '
                      '${product.deliveryOptions.homeDelivery!.estimatedDelivery}',
                  color: Colors.blue,
                ),
              if (product.deliveryOptions.selfPickup?.available == true) ...[
                if (product.deliveryOptions.homeDelivery?.available == true)
                  Divider(color: kPillGrey, height: 24),
                _buildDeliveryOption(
                  icon: Icons.store,
                  title: 'Self Pickup',
                  subtitle:
                      'FREE • ${product.deliveryOptions.selfPickup!.address}',
                  color: Colors.green,
                ),
              ],
              if (product.deliveryOptions.expressDelivery?.available ==
                  true) ...[
                if (product.deliveryOptions.homeDelivery?.available == true ||
                    product.deliveryOptions.selfPickup?.available == true)
                  Divider(color: kPillGrey, height: 24),
                _buildDeliveryOption(
                  icon: Icons.flash_on,
                  title: 'Express Delivery',
                  subtitle:
                      'Rp ${NumberFormat('#,###').format(product.deliveryOptions.expressDelivery!.fee)} • '
                      '${product.deliveryOptions.expressDelivery!.estimatedDelivery}',
                  color: Colors.orange,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kDarkGreen)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: kTextGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulkPricing(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bulk Pricing',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          ...product.bulkPricing!.map((bulk) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPillGrey, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bulk.minQuantity}${bulk.maxQuantity != null ? '-${bulk.maxQuantity}' : '+'} ${product.unit}',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, color: kDarkGreen),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Save ${bulk.discountPercentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF10B981), fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(bulk.pricePerUnit),
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingReviews(BuildContext context, ProductDetail product) {
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
                product.rating.average.toStringAsFixed(1),
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
                          index < product.rating.average.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: kAccentOrange,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Based on ${product.rating.count} reviews',
                        style: GoogleFonts.inter(color: kTextGrey)),
                  ],
                ),
              ),
            ],
          ),
          if (product.reviews?.recentReviews != null &&
              product.reviews!.recentReviews!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            ...product.reviews!.recentReviews!.take(2).map((review) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: review.buyer.profilePicture != null
                              ? NetworkImage(review.buyer.profilePicture!)
                              : null,
                          child: review.buyer.profilePicture == null
                              ? Text(review.buyer.name[0])
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(review.buyer.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  if (review.buyer.isVerifiedPurchase) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified,
                                        size: 14, color: Colors.green),
                                  ],
                                ],
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (review.title != null) ...[
                      Text(review.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                    ],
                    Text(review.comment),
                    if (review.images != null && review.images!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: review.images!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  review.images![index].thumbnailUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Products',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.relatedProducts!.length,
              itemBuilder: (context, index) {
                final relatedProduct = product.relatedProducts![index];
                return GestureDetector(
                  onTap: () => _viewProduct(relatedProduct.productId),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPillGrey, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            relatedProduct.image ?? '',
                            width: 150,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 120,
                                color: kPillGrey,
                                child:
                                    const Icon(Icons.image, color: kTextGrey),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                relatedProduct.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkGreen),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0)
                                    .format(relatedProduct.price),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kDarkGreen),
                              ),
                              if (relatedProduct.rating != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: kAccentOrange, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      relatedProduct.rating!.toStringAsFixed(1),
                                      style: GoogleFonts.inter(
                                          fontSize: 11, color: kTextGrey),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetail product) {
    // Check if this is a pre-order product
    final isPreOrder = product.canPreOrder && product.preOrderInfo != null;

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
        child: isPreOrder
            ? _buildPreOrderBottomBar(context, product)
            : _buildRegularBottomBar(context, product),
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
            child: Text('Buy Now',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // Pre-order bottom bar with special styling
  Widget _buildPreOrderBottomBar(BuildContext context, ProductDetail product) {
    final preOrderInfo = product.preOrderInfo!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Harvest countdown banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: kPreOrderBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule, size: 16, color: kPreOrderBlue),
              const SizedBox(width: 6),
              Text(
                'Harvest in ${preOrderInfo.daysUntilHarvest} days • ${preOrderInfo.availableQuantity} ${product.unit} left',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kPreOrderBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Quantity Selector
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

            const SizedBox(width: 12),

            // Pre-Order Button with special styling
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handlePreOrder(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPreOrderBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event_available, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      preOrderInfo.requiresDeposit
                          ? 'Pre-Order (${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(preOrderInfo.depositAmount ?? product.price * 0.2)} deposit)'
                          : 'Pre-Order Now',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handlePreOrder(ProductDetail product) {
    // Show pre-order confirmation dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _buildPreOrderConfirmationSheet(product),
    );
  }

  Widget _buildPreOrderConfirmationSheet(ProductDetail product) {
    final preOrderInfo = product.preOrderInfo!;
    final state = ref.read(productDetailControllerProvider(widget.slug));
    final quantity = state.maybeWhen(
      data: (_, __, q, ___) => q,
      orElse: () => 1,
    );
    final totalPrice = product.finalPrice * quantity;
    final depositAmount = preOrderInfo.requiresDeposit
        ? (preOrderInfo.depositAmount ?? totalPrice * 0.2)
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPreOrderBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.event_available, color: kPreOrderBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Pre-Order',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                        ),
                      ),
                      Text(
                        'Reserve your fresh produce',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: kTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Product summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.images.first.url,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                        Text(
                          '$quantity ${product.unit} × ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.finalPrice)}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(totalPrice),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kDarkGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Harvest info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kFreshGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: kFreshGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harvest Date',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: kTextGrey,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy')
                              .format(preOrderInfo.harvestDate),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kFreshGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${preOrderInfo.daysUntilHarvest} days',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Deposit info if required
            if (preOrderInfo.requiresDeposit) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 18, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'Deposit Required',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pay now:',
                          style: GoogleFonts.inter(color: kTextGrey),
                        ),
                        Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(depositAmount),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pay on delivery:',
                          style: GoogleFonts.inter(color: kTextGrey),
                        ),
                        Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(totalPrice - depositAmount),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmPreOrder(product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPreOrderBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  preOrderInfo.requiresDeposit
                      ? 'Pay Deposit & Reserve'
                      : 'Confirm Pre-Order',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'You can cancel up to 24 hours before harvest',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: kTextGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPreOrder(ProductDetail product) {
    // TODO: Implement actual pre-order API call
    _showSnackBar('Pre-order confirmed! You will be notified when ready.');
  }

  void _toggleFavorite(WidgetRef ref, bool currentStatus) async {
    ref.read(productDetailControllerProvider(widget.slug).notifier).toggleFavorite();
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
    // TODO: Implement share functionality
    _showSnackBar('Share product: ${product.name}');
  }

  void _viewSellerProfile(String sellerId) {
    // TODO: Navigate to seller profile
    _showSnackBar('View seller profile: $sellerId');
  }

  void _viewAllReviews(ProductDetail product) {
    // TODO: Navigate to reviews screen
    _showSnackBar('View all ${product.rating.count} reviews');
  }

  void _viewProduct(String slug) {
    // Optionally pop current screen if you want to avoid deep stack,
    // or push to maintain history.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(slug: slug),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
