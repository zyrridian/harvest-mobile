import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_order.dart';
import '../providers/farmer_orders_controller.dart';
import 'package:intl/intl.dart';

const kBgColor = Color(0xFFF7F9F8);
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
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _orderType = 'standard'; // 'standard' or 'pre_orders'

  final List<String> _tabs = [
    'All',
    'Pending Payment',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Completed',
    'Cancelled'
  ];

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
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      appBar: AppBar(
        title: Text(
          'Orders & Schedules',
          style: TextStyle(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              _buildSegmentedControl(),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: kDarkGreen,
                unselectedLabelColor: kTextGrey,
                indicatorColor: kAccentOrange,
                indicatorWeight: 3,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: ordersState.maybeWhen(
        loading: () => _buildShimmerList(),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search order number or buyer...',
                  prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass, color: kTextGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kAccentOrange),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tab) {
                  final statusFilter = _statusMap[tab]!;
                  final filteredOrders = orders.where((o) {
                    final matchesStatus = statusFilter == 'all' || o.status.toLowerCase() == statusFilter;
                    final matchesSearch = _searchQuery.isEmpty ||
                        o.orderNumber.toLowerCase().contains(_searchQuery) ||
                        o.buyerName.toLowerCase().contains(_searchQuery);
                    final isHarvestSchedule = o.deliveryMethod == 'harvest_schedule';
                    final matchesType = _orderType == 'standard' ? !isHarvestSchedule : isHarvestSchedule;
                    return matchesStatus && matchesSearch && matchesType;
                  }).toList();
                  return _buildOrdersTab(filteredOrders);
                }).toList(),
              ),
            ),
          ],
        ),
        orElse: () => const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'routePlanFab',
        onPressed: () {
          context.push(AppRouter.routePlan);
        },
        backgroundColor: kAccentOrange,
        icon: const Icon(PhosphorIconsRegular.mapTrifold, color: Colors.white),
        label: Text('Route Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              onTap: () => setState(() => _orderType = 'standard'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _orderType == 'standard' ? kPrimaryGreen.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Standard Orders',
                    style: TextStyle(
                      fontWeight: _orderType == 'standard' ? FontWeight.bold : FontWeight.w500,
                      color: _orderType == 'standard' ? kDarkGreen : kTextGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _orderType = 'pre_orders'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _orderType == 'pre_orders' ? kPrimaryGreen.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Pre-orders',
                    style: TextStyle(
                      fontWeight: _orderType == 'pre_orders' ? FontWeight.bold : FontWeight.w500,
                      color: _orderType == 'pre_orders' ? kDarkGreen : kTextGrey,
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

  Widget _buildOrdersTab(List<FarmerOrder> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(color: kTextGrey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
      color: kDarkGreen,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildOrderCard(orders[index]);
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                const Divider(height: 1),
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
          // Normal order detail navigation could go here
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
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
                  style: TextStyle(
                    color: kTextGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReady ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusDisplay,
                    style: TextStyle(
                      color: isReady ? Colors.green : kAccentOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.items.map((i) => '${i.quantity}x ${i.productName}').join(', '),
                        style: TextStyle(
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
                  style: TextStyle(
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
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
                if (isHarvestSchedule)
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: kAccentOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Update Status',
                    style: TextStyle(
                      color: kDarkGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
