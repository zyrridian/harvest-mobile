import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../domain/entities/farmer_order.dart';
import '../providers/farmer_orders_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(farmerOrdersControllerProvider(status: 'all'));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'Orders & Schedules',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: kDarkGreen,
          unselectedLabelColor: kTextGrey,
          indicatorColor: kAccentOrange,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Direct'),
            Tab(text: 'Pre-orders'),
            Tab(text: 'Harvests'),
          ],
        ),
      ),
      body: ordersState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) => TabBarView(
          controller: _tabController,
          children: [
            _buildOrdersTab(orders.where((o) => o.deliveryMethod == 'pickup' || o.deliveryMethod == 'direct').toList(), isHarvest: false),
            _buildOrdersTab(orders.where((o) => o.deliveryMethod == 'pre-order').toList(), isHarvest: false),
            _buildOrdersTab(orders.where((o) => o.deliveryMethod == 'harvest_schedule').toList(), isHarvest: true),
          ],
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildOrdersTab(List<FarmerOrder> orders, {required bool isHarvest}) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: GoogleFonts.inter(color: kTextGrey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(farmerOrdersControllerProvider(status: 'all').notifier).refresh(),
      color: kDarkGreen,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildOrderCard(orders[index], isHarvestSchedule: isHarvest);
        },
      ),
    );
  }

  Widget _buildOrderCard(FarmerOrder data, {required bool isHarvestSchedule}) {
    final isReady = data.status.toLowerCase() == 'ready' || data.status.toLowerCase() == 'confirmed';

    return InkWell(
      onTap: () {
        if (isHarvestSchedule) {
          context.push(AppRouter.harvestScheduleDetail);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.orderNumber,
                  style: GoogleFonts.inter(
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
                    data.status,
                    style: GoogleFonts.inter(
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
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFF0F5F2),
                  child: Icon(PhosphorIconsRegular.user, color: kDarkGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.buyerName,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.items.map((i) => '${i.quantity}x ${i.productName}').join(', '),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: kTextGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
                      'Date TBD', // data.date
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
                if (isHarvestSchedule)
                  Text(
                    'View Details',
                    style: GoogleFonts.inter(
                      color: kAccentOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Update Status',
                    style: GoogleFonts.inter(
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
