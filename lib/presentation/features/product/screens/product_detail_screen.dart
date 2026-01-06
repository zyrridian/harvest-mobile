import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/product_detail.dart';
import '../../../providers/product_detail_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

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
      ref.read(trackProductViewUseCaseProvider).call(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: kBgColor,
      body: productAsync.when(
        data: (product) => _buildProductDetail(context, product),
        loading: () => const Center(
          child: CircularProgressIndicator(color: kDarkGreen),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(productDetailProvider(widget.productId)),
                style: ElevatedButton.styleFrom(backgroundColor: kDarkGreen),
                child:
                    const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) => _buildBottomBar(context, product),
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
                final isFavorite =
                    ref.watch(isFavoriteProvider(widget.productId));
                return IconButton(
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20),
                  color: isFavorite ? kAccentOrange : kDarkGreen,
                  onPressed: () => _toggleFavorite(ref, isFavorite),
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
                    style: GoogleFonts.dmSans(
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
          style: GoogleFonts.playfairDisplay(
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
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.rating.count} reviews)',
              style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 14),
            ),
            const Spacer(),
            Text(
              '${NumberFormat('#,###').format(product.stats.orders)} sold',
              style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 14),
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
              style: GoogleFonts.dmSans(
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
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${product.unit}',
                style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 16),
              ),
            ],
          ),
          if (product.hasDiscount && product.discount!.savings != null) ...[
            const SizedBox(height: 4),
            Text(
              'Save ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.discount!.savings)}',
              style: GoogleFonts.dmSans(
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
        style: GoogleFonts.dmSans(
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
                        style: GoogleFonts.dmSans(
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
                  style: GoogleFonts.dmSans(fontSize: 12, color: kTextGrey),
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
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
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
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: kTextGrey,
            height: 1.6,
          ),
        ),
        if (product.longDescription != null) ...[
          const SizedBox(height: 12),
          Text(
            product.longDescription!,
            style: GoogleFonts.dmSans(
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
          style: GoogleFonts.playfairDisplay(
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
                            GoogleFonts.dmSans(color: kTextGrey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        spec.value,
                        style: GoogleFonts.dmSans(
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
            style: GoogleFonts.playfairDisplay(
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
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen)),
                        const SizedBox(height: 4),
                        Text('Issued by: ${cert.issuer}',
                            style: GoogleFonts.dmSans(
                                fontSize: 12, color: kTextGrey)),
                        Text(
                            'Valid until: ${DateFormat('dd MMM yyyy').format(cert.expiryDate)}',
                            style: GoogleFonts.dmSans(
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
          style: GoogleFonts.playfairDisplay(
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
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kDarkGreen)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: GoogleFonts.dmSans(fontSize: 12, color: kTextGrey)),
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
            style: GoogleFonts.playfairDisplay(
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
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.bold, color: kDarkGreen),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Save ${bulk.discountPercentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.dmSans(
                            color: const Color(0xFF10B981), fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(bulk.pricePerUnit),
                    style: GoogleFonts.playfairDisplay(
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
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              TextButton(
                onPressed: () => _viewAllReviews(product),
                child: Text('View All',
                    style: GoogleFonts.dmSans(color: kAccentOrange)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                product.rating.average.toStringAsFixed(1),
                style: GoogleFonts.playfairDisplay(
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
                        style: GoogleFonts.dmSans(color: kTextGrey)),
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
            style: GoogleFonts.playfairDisplay(
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
                                style: GoogleFonts.dmSans(
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
                                style: GoogleFonts.playfairDisplay(
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
                                      style: GoogleFonts.dmSans(
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
        child: Row(
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
                      final quantity =
                          ref.watch(productQuantityProvider(widget.productId));
                      return Text(
                        '$quantity',
                        style: GoogleFonts.dmSans(
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

            // 2. Add to Cart Button (FIX: Removed Expanded)
            // Adding specific width or minimumSize makes it a nice square
            ElevatedButton(
              onPressed: product.isInStock ? () => _addToCart(product) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                // Fix the width to be equal to height for a square look
                minimumSize: const Size(54, 54),
                padding: EdgeInsets.zero, // Remove padding to center icon
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.white, size: 22),
              // const SizedBox(width: 8),
              // Text('Add to Cart',
              //     style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(width: 12),

            // 3. Buy Now Button (Keeps Expanded to take remaining space)
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
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(WidgetRef ref, bool currentStatus) async {
    // Optimistic update
    ref.read(isFavoriteProvider(widget.productId).notifier).state =
        !currentStatus;

    if (currentStatus) {
      final result = await ref
          .read(removeProductFromFavoritesUseCaseProvider)
          .call(widget.productId);
      result.fold(
        (failure) {
          // Revert on failure
          ref.read(isFavoriteProvider(widget.productId).notifier).state =
              currentStatus;
          _showSnackBar('Failed to remove from favorites');
        },
        (_) {
          _showSnackBar('Removed from favorites');
          ref.invalidate(productDetailProvider(widget.productId));
        },
      );
    } else {
      final result = await ref
          .read(addProductToFavoritesUseCaseProvider)
          .call(widget.productId);
      result.fold(
        (failure) {
          // Revert on failure
          ref.read(isFavoriteProvider(widget.productId).notifier).state =
              currentStatus;
          _showSnackBar('Failed to add to favorites');
        },
        (_) {
          _showSnackBar('Added to favorites');
          ref.invalidate(productDetailProvider(widget.productId));
        },
      );
    }
  }

  void _incrementQuantity(ProductDetail product) {
    final currentQuantity = ref.read(productQuantityProvider(widget.productId));
    if (currentQuantity < product.maximumOrder) {
      ref.read(productQuantityProvider(widget.productId).notifier).state =
          currentQuantity + 1;
    } else {
      _showSnackBar('Maximum order: ${product.maximumOrder} ${product.unit}');
    }
  }

  void _decrementQuantity(ProductDetail product) {
    final currentQuantity = ref.read(productQuantityProvider(widget.productId));
    if (currentQuantity > product.minimumOrder) {
      ref.read(productQuantityProvider(widget.productId).notifier).state =
          currentQuantity - 1;
    }
  }

  void _addToCart(ProductDetail product) {
    final quantity = ref.read(productQuantityProvider(widget.productId));
    // Navigate to cart screen
    _showSnackBar('Added $quantity ${product.unit} to cart');
    ref.read(isInCartProvider(widget.productId).notifier).state = true;

    // Navigate to cart after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushNamed(context, '/cart');
      }
    });
  }

  void _buyNow(ProductDetail product) {
    final quantity = ref.read(productQuantityProvider(widget.productId));
    // Navigate directly to checkout for buy now
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

  void _viewProduct(String productId) {
    // Navigate to another product detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: productId),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
