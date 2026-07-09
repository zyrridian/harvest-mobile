import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_product.dart';
import '../../../../shared_widgets/app_cached_image.dart';
import '../providers/farmer_products_controller.dart';
import 'package:harvest_app/presentation/features/producer/preorder/screens/create_preorder_campaign_screen.dart';
import '../providers/farmer_campaigns_controller.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:intl/intl.dart';

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
  ConsumerState<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState
    extends ConsumerState<ProductManagementScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _productType = 'ready_stock'; // 'ready_stock' or 'pre_orders'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(farmerProductsControllerProvider);
    final currentFilter =
        ref.read(farmerProductsControllerProvider.notifier).currentFilter;

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
                  ref
                      .read(farmerProductsControllerProvider.notifier)
                      .setSearchQuery(value);
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
                  ref
                      .read(farmerProductsControllerProvider.notifier)
                      .setSearchQuery('');
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
              icon: const Icon(PhosphorIconsRegular.magnifyingGlass,
                  color: kDarkGreen),
            ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              _buildSegmentedControl(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip('Active', 'active', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip('Inactive', 'inactive', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'Out of Stock', 'out_of_stock', currentFilter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _productType == 'ready_stock'
          ? productsState.maybeWhen(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: kDarkGreen)),
              error: (error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error, style: GoogleFonts.inter(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(farmerProductsControllerProvider.notifier)
                          .refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (products) => RefreshIndicator(
                onRefresh: () => ref
                    .read(farmerProductsControllerProvider.notifier)
                    .refresh(),
                color: kDarkGreen,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 100),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            )
          : _buildCampaignsTab(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addProductFab',
        onPressed: () => _showAddOptions(context),
        backgroundColor: kDarkGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _productType = 'ready_stock'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _productType == 'ready_stock'
                      ? kPrimaryGreen.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Ready Stock',
                    style: GoogleFonts.inter(
                      fontWeight: _productType == 'ready_stock'
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: _productType == 'ready_stock'
                          ? kDarkGreen
                          : kTextGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _productType = 'pre_orders'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _productType == 'pre_orders'
                      ? kPrimaryGreen.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Pre-orders / Harvests',
                    style: GoogleFonts.inter(
                      fontWeight: _productType == 'pre_orders'
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color:
                          _productType == 'pre_orders' ? kDarkGreen : kTextGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(PhosphorIconsFill.package,
                        color: kPrimaryGreen),
                  ),
                  title: Text(
                    'Standard Product',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'List items you have ready in stock',
                    style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRouter.addProduct);
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kAccentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(PhosphorIconsFill.calendar,
                        color: kAccentOrange),
                  ),
                  title: Text(
                    'Preorder Campaign',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Set up a future harvest schedule for pre-order',
                    style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreatePreorderCampaignScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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
            content:
                const Text('Are you sure you want to delete this product?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref
            .read(farmerProductsControllerProvider.notifier)
            .deleteProduct(product.id);
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
                          color: inStock
                              ? kAccentOrange
                              : kTextGrey.withOpacity(0.5),
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
                        ref
                            .read(farmerProductsControllerProvider.notifier)
                            .toggleAvailability(product.id, value);
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

  Widget _buildCampaignsTab() {
    final campaignsState = ref.watch(farmerCampaignsControllerProvider);

    return campaignsState.maybeWhen(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString(), style: GoogleFonts.inter(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(farmerCampaignsControllerProvider.notifier)
                  .refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (campaigns) {
        if (campaigns.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(PhosphorIconsRegular.calendarBlank,
                    size: 48, color: kTextGrey),
                const SizedBox(height: 16),
                Text(
                  'No pre-order campaigns yet',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create one to start selling before harvest',
                  style: GoogleFonts.inter(color: kTextGrey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreatePreorderCampaignScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Campaign'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentOrange,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(farmerCampaignsControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          child: ListView.separated(
            padding: const EdgeInsets.only(
                top: 16, left: 16, right: 16, bottom: 100),
            itemCount: campaigns.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return _buildCampaignCard(campaign);
            },
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildCampaignCard(PreorderCampaign campaign) {
    final progress = campaign.targetQuantity > 0
        ? campaign.currentReservations / campaign.targetQuantity
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    campaign.productName ?? 'Unknown Product',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: campaign.status == 'active'
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (campaign.status ?? 'Unknown').toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: campaign.status == 'active'
                          ? Colors.green
                          : kTextGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Quantity',
                        style:
                            GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${campaign.targetQuantity}',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, color: kDarkGreen),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reservations',
                        style:
                            GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${campaign.currentReservations}',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, color: kDarkGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: kBorderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? Colors.green : kAccentOrange),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: kBorderColor),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.calendar,
                        size: 16, color: kTextGrey),
                    const SizedBox(width: 4),
                    Text(
                      'Est. Harvest: ${DateFormat('MMM dd').format(campaign.estimatedHarvestDate)}',
                      style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                    ),
                  ],
                ),
                Text(
                  'Manage',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kAccentOrange,
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
