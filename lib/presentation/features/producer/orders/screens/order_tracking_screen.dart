import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_order.dart';
import '../providers/farmer_orders_controller.dart';
import 'package:intl/intl.dart';
import '../../../../shared_widgets/app_search_bar.dart';
import '../../../../shared_widgets/pill_tab_bar.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'Pending Payment',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Completed',
    'Cancelled'
  ];
  int _selectedFilterIndex = 0;

  final Map<String, String> _statusMap = {
    'All': 'all',
    'Pending Payment': 'pending_payment',
    'Confirmed': 'confirmed',
    'Processing': 'processing',
    'Shipped': 'shipped',
    'Delivered': 'delivered',
    'Completed': 'completed',
    'Cancelled': 'cancelled'
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Date TBD';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr.substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(farmerOrdersControllerProvider(status: 'all'));

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: kDarkGreen,
          backgroundColor: Colors.white,
          onRefresh: () async => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
          child: CustomScrollView(
            slivers: [
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
                      'Orders & Schedules',
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
              ordersState.maybeWhen(
                data: (orders) {
                  final statusFilter = _statusMap[_filters[_selectedFilterIndex]]!;
                  final query = _searchController.text.toLowerCase();

                  final filteredOrders = orders.where((o) {
                    final matchesStatus = statusFilter == 'all' || o.status.toLowerCase() == statusFilter;
                    final matchesSearch = query.isEmpty ||
                        o.orderNumber.toLowerCase().contains(query) ||
                        o.buyerName.toLowerCase().contains(query);
                    return matchesStatus && matchesSearch;
                  }).toList();

                  if (filteredOrders.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No orders found',
                          style: TextStyle(color: kTextGrey),
                        ),
                      ),
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
                error: (error) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error.toString(), style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                orElse: () => const SliverFillRemaining(
                  child: SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'routePlanFab',
        onPressed: () {
          context.push(AppRouter.routePlan);
        },
        backgroundColor: kAccentOrange,
        icon: const Icon(PhosphorIconsRegular.mapTrifold, color: Colors.white),
        label: const Text('Route Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 80, height: 14, color: Colors.white),
                      Container(width: 60, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(radius: 20, backgroundColor: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 120, height: 16, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(width: 150, height: 14, color: Colors.white),
                          ],
                        ),
                      ),
                      Container(width: 60, height: 16, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: kBorderColor),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100, height: 14, color: Colors.white),
                      Container(width: 80, height: 14, color: Colors.white),
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

  Widget _buildOrderCard(FarmerOrder data) {
    final isHarvestSchedule = data.deliveryMethod == 'harvest_schedule';
    final isReady = data.status.toLowerCase() == 'ready' || data.status.toLowerCase() == 'confirmed' || data.status.toLowerCase() == 'paid';

    String statusDisplay = data.status.replaceAll('_', ' ');
    statusDisplay = statusDisplay.split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');

    return InkWell(
      onTap: () {
        if (isHarvestSchedule) {
          context.push(AppRouter.harvestScheduleDetail);
        } else {
          context.push('${AppRouter.orderDetail}?orderId=${data.id}');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.orderNumber,
                  style: const TextStyle(
                    color: kTextGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusBadge(data.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F5F2),
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: data.items.isNotEmpty && data.items.first.productImage != null
                      ? Image.network(
                          data.items.first.productImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(PhosphorIconsRegular.user, color: kDarkGreen, size: 20),
                        )
                      : const Icon(PhosphorIconsRegular.user, color: kDarkGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.buyerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.items.map((i) => '${i.quantity}x ${i.productName}').join(', '),
                        style: const TextStyle(
                          fontSize: 13,
                          color: kTextGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(data.totalAmount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kDarkGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: kBorderColor, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.calendar, size: 16, color: kTextGrey),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(data.deliveryDate),
                      style: const TextStyle(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
                if (isHarvestSchedule)
                  const Text(
                    'View Details',
                    style: TextStyle(
                      color: kAccentOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _showUpdateStatusBottomSheet(context, data),
                    child: const Text(
                      'Update Status',
                      style: TextStyle(
                        color: kDarkGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusBottomSheet(BuildContext context, FarmerOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final statuses = [
          'pending_payment',
          'confirmed',
          'processing',
          'shipped',
          'delivered',
          'completed',
          'cancelled'
        ];
        
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Order Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(color: kTextGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ...statuses.map((status) {
                    final isSelected = order.status.toLowerCase() == status.toLowerCase();
                    String statusDisplay = status.replaceAll('_', ' ');
                    statusDisplay = statusDisplay.split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        statusDisplay,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? kDarkGreen : Colors.black87,
                        ),
                      ),
                      trailing: isSelected ? const Icon(PhosphorIconsRegular.checkCircle, color: kDarkGreen) : null,
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(farmerOrdersControllerProvider(status: 'all').notifier).updateOrderStatus(order.id, status);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Status updated to $statusDisplay')),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
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
      case 'shipped':
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        icon = PhosphorIconsRegular.truck;
        break;
      case 'delivered':
      case 'completed':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = PhosphorIconsRegular.checkCircle;
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = PhosphorIconsRegular.xCircle;
        break;
      case 'pending_payment':
      case 'confirmed':
      default:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        icon = PhosphorIconsRegular.clock;
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
            status.replaceAll('_', ' ').toUpperCase(),
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
