import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_product.dart';
import '../providers/farmer_products_controller.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class ProductManagementScreen extends ConsumerStatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ConsumerState<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends ConsumerState<ProductManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(farmerProductsControllerProvider);
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'My Products',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, color: kDarkGreen),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIconsRegular.faders, color: kDarkGreen),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: productsState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(farmerProductsControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (products) => RefreshIndicator(
          onRefresh: () => ref.read(farmerProductsControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.addProduct);
        },
        backgroundColor: kDarkGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Product',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(FarmerProduct product) {
    final inStock = product.stock > 0 && product.isAvailable;
    
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: !inStock
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: inStock ? kDarkGreen : kTextGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Category', // Will be fetched or grouped in the future
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kTextGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)} / ${product.unit}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: inStock ? kAccentOrange : kTextGrey.withOpacity(0.5),
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
                    // Update stock logic will be handled by controller later.
                  },
                ),
                Text(
                  inStock ? 'In Stock' : 'Out of Stock',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: inStock ? kDarkGreen : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
