import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_product.dart';
import '../../../../../domain/entities/preorder_campaign.dart';
import '../../../../shared_widgets/app_cached_image.dart';
import '../../../../shared_widgets/app_search_bar.dart';
import '../../../../shared_widgets/pill_tab_bar.dart';
import '../providers/farmer_products_controller.dart';
import '../providers/farmer_campaigns_controller.dart';
import 'package:harvest_app/presentation/features/producer/preorder/screens/create_preorder_campaign_screen.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kBorderColor = Color(0xFFE5E7EB);
const kTextGrey = Color(0xFF6E7A75);

class FarmerProductScreen extends ConsumerStatefulWidget {
  const FarmerProductScreen({super.key});

  @override
  ConsumerState<FarmerProductScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends ConsumerState<FarmerProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _filters = [
    {'name': 'All', 'value': 'all', 'icon': null},
    {'name': 'Active', 'value': 'active', 'icon': null},
    {'name': 'Inactive', 'value': 'inactive', 'icon': null},
    {'name': 'Out of Stock', 'value': 'out_of_stock', 'icon': null},
  ];
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                backgroundColor: kBgColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 16,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: _isSearchVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  layoutBuilder:
                      (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          key: bottomChildKey,
                          left: 0.0,
                          right: 0.0,
                          child: bottomChild,
                        ),
                        Positioned(
                          key: topChildKey,
                          child: topChild,
                        ),
                      ],
                    );
                  },
                  firstChild: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Center(
                        child: Text(
                          'My Products',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: kDarkGreen,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ) ??
                                  TextStyle(
                                    color: kDarkGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: AppSearchBar(
                      hintText: 'Search products...',
                      height: 38,
                      onChanged: (value) {
                        ref
                            .read(farmerProductsControllerProvider.notifier)
                            .setSearchQuery(value);
                      },
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: PhosphorIcon(
                      _isSearchVisible
                          ? PhosphorIconsRegular.x
                          : PhosphorIconsRegular.magnifyingGlass,
                      color: kDarkGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = !_isSearchVisible;
                        if (!_isSearchVisible) {
                          _searchController.clear();
                          ref
                              .read(farmerProductsControllerProvider.notifier)
                              .setSearchQuery('');
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: kBorderColor, width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: kDarkGreen,
                      unselectedLabelColor: kTextGrey,
                      indicatorColor: kDarkGreen,
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Ready Stock'),
                        Tab(text: 'Pre-orders'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildReadyStockTab(),
              _buildCampaignsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addProductFab',
        onPressed: () => _showAddOptions(context),
        backgroundColor: kDarkGreen,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReadyStockTab() {
    final productsState = ref.watch(farmerProductsControllerProvider);

    return RefreshIndicator(
      color: kDarkGreen,
      backgroundColor: Colors.white,
      onRefresh: () async {
        await ref.read(farmerProductsControllerProvider.notifier).refresh();
      },
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: PillTabBarDelegate(
              height: 52.0,
              child: PillTabBar(
                backgroundColor: kBgColor,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                tabs: _filters
                    .map((f) => PillTabItem(
                          name: f['name'] as String,
                          icon: f['icon'] as IconData?,
                        ))
                    .toList(),
                selectedIndex: _selectedFilterIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                  ref
                      .read(farmerProductsControllerProvider.notifier)
                      .setFilter(_filters[index]['value'] as String);
                },
              ),
            ),
          ),
          productsState.when(
            loading: () => const SliverFillRemaining(
              child:
                  Center(child: CircularProgressIndicator(color: kDarkGreen)),
            ),
            error: (error) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString(), style: TextStyle(color: Colors.red)),
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
            ),
            data: (products) {
              if (products.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('No products found',
                        style: TextStyle(color: kTextGrey)),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.only(top: 0, bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(FarmerProduct product) {
    final inStock = product.stock > 0 && product.isAvailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key(product.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Thumbnail
                  Container(
                    width: 72,
                    height: 72,
                    foregroundDecoration: !inStock
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: AppCachedImage(
                      imageUrl: product.imageUrl,
                      borderRadius: BorderRadius.circular(8),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: inStock ? kDarkGreen : kTextGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)} / ${product.unit}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: inStock
                                ? kDarkGreen
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
                        style: TextStyle(
                          fontSize: 11,
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
      ),
    );
  }

  Widget _buildCampaignsTab() {
    final campaignsState = ref.watch(farmerCampaignsControllerProvider);

    return RefreshIndicator(
      color: kDarkGreen,
      backgroundColor: Colors.white,
      onRefresh: () async {
        await ref.read(farmerCampaignsControllerProvider.notifier).refresh();
      },
      child: CustomScrollView(
        slivers: [
          campaignsState.when(
            loading: () => const SliverFillRemaining(
              child:
                  Center(child: CircularProgressIndicator(color: kDarkGreen)),
            ),
            error: (error, st) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString(), style: TextStyle(color: Colors.red)),
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
            ),
            data: (campaigns) {
              if (campaigns.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(PhosphorIconsRegular.calendarBlank,
                            size: 48, color: kTextGrey),
                        const SizedBox(height: 16),
                        Text(
                          'No pre-order campaigns yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kDarkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create one to start selling before harvest',
                          style: TextStyle(color: kTextGrey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CreatePreorderCampaignScreen(),
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
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final campaign = campaigns[index];
                      return _buildCampaignCard(campaign);
                    },
                    childCount: campaigns.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(PreorderCampaign campaign) {
    final progress = campaign.targetQuantity > 0
        ? campaign.currentReservations / campaign.targetQuantity
        : 0.0;

    final imageUrl = (campaign.images != null && campaign.images!.isNotEmpty)
        ? campaign.images!.first
        : campaign.productImage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () {
          _showReservationsBottomSheet(context, campaign);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppCachedImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  campaign.productName ?? 'Unknown Product',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkGreen,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  (campaign.status ?? 'Unknown').toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (campaign.price != null && campaign.unit != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Rp ${campaign.price} / ${campaign.unit}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kTextGrey,
                                ),
                              ),
                            ),
                        ],
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
                            style: TextStyle(fontSize: 12, color: kTextGrey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${campaign.targetQuantity}',
                            style: TextStyle(
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
                            style: TextStyle(fontSize: 12, color: kTextGrey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${campaign.currentReservations}',
                            style: TextStyle(
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
                      progress >= 1.0 ? kDarkGreen : kAccentOrange),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
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
                            size: 14, color: kTextGrey),
                        const SizedBox(width: 4),
                        Text(
                          'Est. Harvest: ${DateFormat('MMM dd').format(campaign.estimatedHarvestDate)}',
                          style: TextStyle(fontSize: 12, color: kTextGrey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (campaign.status == 'ACTIVE') ...[
                          GestureDetector(
                            onTap: () async {
                              final params = CreatePreorderCampaignParams(
                                title: campaign.productName ?? '',
                                description: campaign.description ?? '',
                                unit: campaign.unit ?? '',
                                pricePerUnit: campaign.price ?? 0,
                                targetQuantity: campaign.targetQuantity,
                                estimatedHarvestDate:
                                    campaign.estimatedHarvestDate,
                                minimumOrderQuantity: 1,
                                depositPercentage:
                                    campaign.depositAmount.toInt(),
                                status: 'READY_FOR_PICKUP',
                                images: campaign.images ??
                                    (campaign.productImage != null
                                        ? [campaign.productImage!]
                                        : []),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Marking as Ready for Pickup...')),
                              );

                              final success = await ref
                                  .read(preOrderControllerProvider.notifier)
                                  .updateCampaign(campaign.id, params);

                              if (success && mounted) {
                                ref
                                    .read(farmerCampaignsControllerProvider
                                        .notifier)
                                    .refresh();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Campaign marked as Ready for Pickup!')),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.checkCircle,
                                    size: 14, color: kDarkGreen),
                                const SizedBox(width: 4),
                                Text(
                                  'Mark Ready',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreatePreorderCampaignScreen(
                                    campaign: campaign),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(PhosphorIconsRegular.pencilSimple,
                                  size: 14, color: kAccentOrange),
                              const SizedBox(width: 4),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kAccentOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _showReservationsBottomSheet(
      BuildContext context, PreorderCampaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reservations for ${campaign.productName ?? 'Campaign'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkGreen,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: kDarkGreen),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: kBorderColor),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target Quantity',
                        style: TextStyle(fontSize: 13, color: kTextGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${campaign.targetQuantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreen,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Total Reserved',
                        style: TextStyle(fontSize: 13, color: kTextGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${campaign.currentReservations}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: kBorderColor),
            Expanded(
              child: (campaign.reservations == null ||
                      campaign.reservations!.isEmpty)
                  ? const Center(
                      child: Text(
                        'No reservations yet.',
                        style: TextStyle(color: kTextGrey, fontSize: 15),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: campaign.reservations!.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: kBorderColor),
                      itemBuilder: (context, index) {
                        final res = campaign.reservations![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100]!,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(PhosphorIconsRegular.user,
                                        color: kDarkGreen, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          res.buyerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreen,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Status: ${res.status.replaceAll('_', ' ')}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: kTextGrey,
                                          ),
                                        ),
                                        if (res.deliveryMethod != null)
                                          Text(
                                            'Delivery: ${res.deliveryMethod}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: kTextGrey,
                                            ),
                                          ),
                                        if (res.addressId != null)
                                          Text(
                                            'Address ID: ${res.addressId!.length > 8 ? res.addressId!.substring(0, 8) : res.addressId}...',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: kTextGrey,
                                            ),
                                          ),
                                        if (res.paymentMethod != null)
                                          Text(
                                            'Payment: ${res.paymentMethod}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: kTextGrey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${res.quantity} ${campaign.unit ?? 'items'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: kAccentOrange,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (res.totalPrice != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            'Rp ${res.totalPrice?.toInt()}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: kDarkGreen,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      if (res.depositAmount != null &&
                                          res.depositAmount! > 0)
                                        Text(
                                          'Dep: Rp ${res.depositAmount?.toInt()}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: kTextGrey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              if (res.status != 'COMPLETED' &&
                                  res.status != 'CANCELLED')
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () async {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Marking as completed...')),
                                        );
                                        final success = await ref
                                            .read(preOrderControllerProvider
                                                .notifier)
                                            .completeReservation(res.id);

                                        if (success && mounted) {
                                          ref
                                              .read(
                                                  farmerCampaignsControllerProvider
                                                      .notifier)
                                              .refresh();
                                          Navigator.pop(context); // Close sheet
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Reservation marked as completed!')),
                                          );
                                        } else if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to complete reservation.')),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: kDarkGreen,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Mark Delivered',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
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
            ),
          ],
        ),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(PhosphorIconsRegular.package,
                        color: kDarkGreen),
                  ),
                  title: Text(
                    'Standard Product',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'List items you have ready in stock',
                    style: TextStyle(fontSize: 12, color: kTextGrey),
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
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(PhosphorIconsRegular.calendar,
                        color: kDarkGreen),
                  ),
                  title: Text(
                    'Preorder Campaign',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Set up a future harvest schedule for pre-order',
                    style: TextStyle(fontSize: 12, color: kTextGrey),
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
}
