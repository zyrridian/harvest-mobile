import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:harvest_app/features/sales/presentation/providers/orders/order_providers.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../core/widgets/app_search_bar.dart';
import '../../../../../core/widgets/pill_tab_bar.dart';
import 'package:harvest_app/features/sales/domain/entities/order.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class OrdersListScreen extends ConsumerStatefulWidget {
  static const routeName = '/orders';

  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Processing', 'Delivered', 'Cancelled'];
  int _selectedFilterIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider(const {'role': 'buyer'}));

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: kDarkGreen,
          backgroundColor: Colors.white,
          onRefresh: () async => ref.refresh(ordersProvider(const {'role': 'buyer'})),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                backgroundColor: kBgColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                centerTitle: false,
                leading: IconButton(
                  icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRouter.main);
                    }
                  },
                ),
                title: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: _isSearchVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  layoutBuilder:
                      (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
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
                    child: Text(
                      'My Orders',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: kDarkGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ) ??
                          const TextStyle(
                            color: kDarkGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: AppSearchBar(
                      hintText: 'Search orders...',
                      height: 38,
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
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
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
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
                              name: f,
                            ))
                        .toList(),
                    selectedIndex: _selectedFilterIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                  ),
                ),
              ),
              ordersAsync.when(
                data: (orders) {
                  List<Order> filteredOrders = List.from(orders);
                  final selectedStatus = _filters[_selectedFilterIndex].toLowerCase();
                  if (selectedStatus != 'all') {
                    filteredOrders = filteredOrders.where((o) => o.status == selectedStatus).toList();
                  }

                  if (_searchController.text.isNotEmpty) {
                    final query = _searchController.text.toLowerCase();
                    filteredOrders = filteredOrders.where((o) {
                      return (o.orderNumber.toLowerCase().contains(query)) ||
                             (o.seller.name.toLowerCase().contains(query));
                    }).toList();
                  }

                  if (filteredOrders.isEmpty) {
                    return SliverFillRemaining(
                      child: _buildEmptyState(),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = filteredOrders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: _buildOrderCard(order),
                          );
                        },
                        childCount: filteredOrders.length,
                      ),
                    ),
                  );
                },
                loading: () => SliverFillRemaining(
                  child: _buildShimmerList(),
                ),
                error: (e, st) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const PhosphorIcon(PhosphorIconsRegular.warningCircle, size: 48, color: kTextGrey),
                        const SizedBox(height: 16),
                        Text('Error: $e', style: const TextStyle(color: kTextGrey)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(ordersProvider(const {'role': 'buyer'})),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: kPillGrey,
              shape: BoxShape.circle,
            ),
            child: const PhosphorIcon(PhosphorIconsRegular.shoppingBag,
                size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your orders will appear here',
            style: TextStyle(color: kTextGrey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go(AppRouter.main),
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: 5,
        itemBuilder: (context, idx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100, height: 20, color: Colors.white),
                      Container(width: 80, height: 20, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 150, height: 16, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(width: 100, height: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: kBorderColor, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 80, height: 12, color: Colors.white),
                          const SizedBox(height: 4),
                          Container(width: 100, height: 20, color: Colors.white),
                        ],
                      ),
                      Container(width: 40, height: 40, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRouter.orderDetail}?orderId=${order.orderId}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const SizedBox(height: 12),

            // Seller Info
            Row(
              children: [
                const PhosphorIcon(PhosphorIconsRegular.storefront, size: 16, color: kTextGrey),
                const SizedBox(width: 6),
                Text(
                  order.seller.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kTextGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Products Info
            Row(
              children: [
                // Images
                Row(
                  children: List.generate(
                    order.items.length > 3 ? 3 : order.items.length,
                    (index) {
                      final item = order.items[index];
                      final isLast = index == 2 && order.items.length > 3;
                      final imageUrl = item.imageUrl;
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: kPillGrey,
                          borderRadius: BorderRadius.circular(8),
                          image: imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: isLast
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '+${order.items.length - 2}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : imageUrl == null
                                ? const Center(
                                    child: PhosphorIcon(PhosphorIconsRegular.image, color: kTextGrey),
                                  )
                                : null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Product Names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.items.map((e) => e.name).join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreen,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: kBorderColor, height: 1),
            ),

            // Total & Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${order.totalAmount}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kDarkGreen,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPillGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const PhosphorIcon(
                    PhosphorIconsRegular.caretRight,
                    size: 16,
                    color: kDarkGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'processing':
        bgColor = kAccentOrange.withOpacity(0.1);
        textColor = kAccentOrange;
        icon = PhosphorIconsRegular.arrowsClockwise;
        break;
      case 'delivered':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = PhosphorIconsRegular.checkCircle;
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = PhosphorIconsRegular.xCircle;
        break;
      default:
        bgColor = kPillGrey;
        textColor = kTextGrey;
        icon = PhosphorIconsRegular.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
