import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/product_detail.dart';
import '../../../providers/product_detail_providers.dart';

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
      body: productAsync.when(
        data: (product) => _buildProductDetail(context, product),
        loading: () => const Center(child: CircularProgressIndicator()),
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
                child: const Text('Retry'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductHeader(context, product),
              const Divider(height: 1),
              _buildPriceSection(context, product),
              const Divider(height: 1),
              _buildLabels(context, product),
              const Divider(height: 1, thickness: 8),
              _buildSellerInfo(context, product),
              const Divider(height: 1, thickness: 8),
              _buildDescription(context, product),
              if (product.specifications != null &&
                  product.specifications!.isNotEmpty) ...[
                const Divider(height: 1, thickness: 8),
                _buildSpecifications(context, product),
              ],
              if (product.certifications != null &&
                  product.certifications!.isNotEmpty) ...[
                const Divider(height: 1, thickness: 8),
                _buildCertifications(context, product),
              ],
              const Divider(height: 1, thickness: 8),
              _buildDeliveryOptions(context, product),
              if (product.bulkPricing != null &&
                  product.bulkPricing!.isNotEmpty) ...[
                const Divider(height: 1, thickness: 8),
                _buildBulkPricing(context, product),
              ],
              const Divider(height: 1, thickness: 8),
              _buildRatingReviews(context, product),
              if (product.relatedProducts != null &&
                  product.relatedProducts!.isNotEmpty) ...[
                const Divider(height: 1, thickness: 8),
                _buildRelatedProducts(context, product),
              ],
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ProductDetail product) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
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
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${product.images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            if (product.hasDiscount)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-${product.discount!.value.toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final isFavorite = ref.watch(isFavoriteProvider(widget.productId));
            return IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite ? Colors.red : null,
              onPressed: () => _toggleFavorite(ref, isFavorite),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareProduct(product),
        ),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                product.rating.average.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text('(${product.rating.count} reviews)'),
              const Spacer(),
              Text(
                '${NumberFormat('#,###').format(product.stats.orders)} sold',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, ProductDetail product) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.hasDiscount) ...[
            Text(
              NumberFormat.currency(
                      locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                  .format(product.price),
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${product.unit}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          if (product.hasDiscount && product.discount!.savings != null) ...[
            const SizedBox(height: 4),
            Text(
              'Save ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(product.discount!.savings)}',
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: labels,
      ),
    );
  }

  Widget _buildLabelChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle:
          TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildSellerInfo(BuildContext context, ProductDetail product) {
    final seller = product.seller;
    return InkWell(
      onTap: () => _viewSellerProfile(seller.userId),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: seller.profilePicture != null
                  ? NetworkImage(seller.profilePicture!)
                  : null,
              child:
                  seller.profilePicture == null ? Text(seller.name[0]) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(seller.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (seller.verified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            size: 16, color: Colors.blue),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${seller.location.city}, ${seller.location.province}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (seller.location.distance != null) ...[
                        const Text(' • ', style: TextStyle(color: Colors.grey)),
                        Text(
                          '${seller.location.distance!.toStringAsFixed(1)} km',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                          '${seller.rating} • ${seller.totalProducts ?? 0} products'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(product.description),
          if (product.longDescription != null) ...[
            const SizedBox(height: 12),
            Text(product.longDescription!),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecifications(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...product.specifications!.map((spec) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      spec.key,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                      child: Text(spec.value,
                          style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCertifications(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...product.certifications!.map((cert) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (cert.verified)
                      const Icon(Icons.verified, color: Colors.green, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cert.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Issued by: ${cert.issuer}',
                              style: const TextStyle(fontSize: 12)),
                          Text(
                              'Valid until: ${DateFormat('dd MMM yyyy').format(cert.expiryDate)}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (product.deliveryOptions.homeDelivery?.available == true) ...[
            _buildDeliveryOption(
              icon: Icons.local_shipping,
              title: 'Home Delivery',
              subtitle:
                  'Rp ${NumberFormat('#,###').format(product.deliveryOptions.homeDelivery!.fee)} • '
                  '${product.deliveryOptions.homeDelivery!.estimatedDelivery}',
              color: Colors.blue,
            ),
          ],
          if (product.deliveryOptions.selfPickup?.available == true) ...[
            const SizedBox(height: 8),
            _buildDeliveryOption(
              icon: Icons.store,
              title: 'Self Pickup',
              subtitle: 'FREE • ${product.deliveryOptions.selfPickup!.address}',
              color: Colors.green,
            ),
          ],
          if (product.deliveryOptions.expressDelivery?.available == true) ...[
            const SizedBox(height: 8),
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulkPricing(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bulk Pricing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...product.bulkPricing!.map((bulk) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bulk.minQuantity}${bulk.maxQuantity != null ? '-${bulk.maxQuantity}' : '+'} ${product.unit}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Save ${bulk.discountPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      NumberFormat.currency(
                              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(bulk.pricePerUnit),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRatingReviews(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ratings & Reviews',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _viewAllReviews(product),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                product.rating.average.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Based on ${product.rating.count} reviews'),
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
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context, ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Products',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
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
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                            child: Image.network(
                              relatedProduct.image ?? '',
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 150,
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  relatedProduct.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0)
                                      .format(relatedProduct.price),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                if (relatedProduct.rating != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        relatedProduct.rating!
                                            .toStringAsFixed(1),
                                        style: const TextStyle(fontSize: 10),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _decrementQuantity(product),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final quantity =
                          ref.watch(productQuantityProvider(widget.productId));
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(quantity.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _incrementQuantity(product),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.isInStock ? () => _addToCart(product) : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(product.isInStock ? 'Add to Cart' : 'Out of Stock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Buy Now Button
            Expanded(
              child: ElevatedButton(
                onPressed: product.isInStock ? () => _buyNow(product) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Buy Now'),
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
    // TODO: Implement add to cart functionality
    _showSnackBar('Added $quantity ${product.unit} to cart');
    ref.read(isInCartProvider(widget.productId).notifier).state = true;
  }

  void _buyNow(ProductDetail product) {
    final quantity = ref.read(productQuantityProvider(widget.productId));
    // TODO: Implement buy now functionality (navigate to checkout)
    _showSnackBar('Buy $quantity ${product.unit} now - Navigate to checkout');
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
