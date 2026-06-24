import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_product.dart';
import '../../../../shared_widgets/app_cached_image.dart';
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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(farmerProductsControllerProvider);
    final currentFilter = ref.read(farmerProductsControllerProvider.notifier).currentFilter;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  hintStyle: GoogleFonts.inter(color: kTextGrey),
                ),
                style: GoogleFonts.inter(color: kDarkGreen),
                onChanged: (value) {
                  ref.read(farmerProductsControllerProvider.notifier).setSearchQuery(value);
                },
              )
            : Text(
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
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  ref.read(farmerProductsControllerProvider.notifier).setSearchQuery('');
                });
              },
              icon: const Icon(Icons.close, color: kDarkGreen),
            )
          else
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(PhosphorIconsRegular.magnifyingGlass, color: kDarkGreen),
            ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', 'all', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip('Active', 'active', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip('Inactive', 'inactive', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip('Out of Stock', 'out_of_stock', currentFilter),
              ],
            ),
          ),
        ),
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
        heroTag: 'addProductFab',
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

  Widget _buildFilterChip(String label, String value, String currentFilter) {
    final isSelected = currentFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(farmerProductsControllerProvider.notifier).setFilter(value);
        }
      },
      selectedColor: kDarkGreen,
      labelStyle: GoogleFonts.inter(
        color: isSelected ? Colors.white : kDarkGreen,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? kDarkGreen : kBorderColor),
      ),
    );
  }

  Widget _buildProductCard(FarmerProduct product) {
    final inStock = product.stock > 0 && product.isAvailable;
    
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text('Are you sure you want to delete this product?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(farmerProductsControllerProvider.notifier).deleteProduct(product.id);
      },
      child: GestureDetector(
        onTap: () {
          context.push(AppRouter.addProduct, extra: product.id);
        },
        child: Container(
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
                  foregroundDecoration: !inStock
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: AppCachedImage(
                    imageUrl: product.imageUrl,
                    borderRadius: BorderRadius.circular(12),
                    fit: BoxFit.cover,
                  ),
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
                        'Stock: ${product.stock}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: kTextGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)} / ${product.unit}',
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
                        ref.read(farmerProductsControllerProvider.notifier).toggleAvailability(product.id, value);
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
        ),
      ),
    );
  }
}
