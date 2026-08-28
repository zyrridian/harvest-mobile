import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_order.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_stats.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmer_dashboard_controller.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/drop_points_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(farmerDashboardControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: _buildAppBar(context),
      body: dashboardState.maybeWhen(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(farmerDashboardControllerProvider.notifier)
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) => RefreshIndicator(
          onRefresh: () =>
              ref.read(farmerDashboardControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Route to Wallet/Earnings screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigate to Wallet')),
                    );
                  },
                  child: _buildRevenueCard(stats),
                ),
                const SizedBox(height: 24),
                const _QuickActionsRow(),
                const SizedBox(height: 24),
                const _ActiveDropPointsCard(),
                // const SizedBox(height: 16),
                // _buildSourcingRequestsBanner(context),
                // const SizedBox(height: 12),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton.icon(
                //     onPressed: () =>
                //         context.push(AppRouter.farmerSourcingOffers),
                //     icon: const Icon(PhosphorIconsRegular.listChecks,
                //         color: kDarkGreen, size: 20),
                //     label: const Text(
                //       'View My Submitted Offers',
                //       style: TextStyle(
                //           color: kDarkGreen, fontWeight: FontWeight.w600),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 24),
                // _buildSectionHeader('Urgent Orders', 'View all'),
                // const SizedBox(height: 16),
                // _buildUrgentOrders(stats.recentOrders),
                // const SizedBox(height: 32),
                // _buildSectionHeader('Today\'s Harvest Pickups', 'Schedule'),
                // const SizedBox(height: 16),
                // _buildHarvestTimeline(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBgColor,
      surfaceTintColor: kBgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      centerTitle: false,
      titleSpacing: 24.0,
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(
                color: kTextGrey,
                fontSize: 14,
              ),
            ),
            Text(
              'Green Valley Farm',
              style: TextStyle(
                color: kDarkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(top: 8, right: 16),
      //     child: Row(
      //       children: [
      //         IconButton(
      //           onPressed: () => context.push(AppRouter.notifications),
      //           icon: Stack(
      //             children: [
      //               const Icon(PhosphorIconsRegular.bell, color: kDarkGreen),
      //               Positioned(
      //                 right: 2,
      //                 top: 2,
      //                 child: Container(
      //                   width: 8,
      //                   height: 8,
      //                   decoration: const BoxDecoration(
      //                     color: kAccentOrange,
      //                     shape: BoxShape.circle,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildRevenueCard(FarmerStats stats) {
    // Basic calculation for trend (mock logic for demo)
    final trendValue = stats.lastMonthRevenue > 0
        ? ((stats.thisMonthRevenue - stats.lastMonthRevenue) /
            stats.lastMonthRevenue *
            100)
        : 100.0;
    final isPositive = trendValue >= 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kDarkGreen, kPrimaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kDarkGreen.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                'This Month Revenue',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                        isPositive
                            ? PhosphorIconsFill.trendUp
                            : PhosphorIconsFill.trendDown,
                        color: Colors.white,
                        size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${trendValue.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.currency(
                    locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                .format(stats.thisMonthRevenue),
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem('Orders', stats.totalOrders.toString()),
              Container(
                height: 30,
                width: 1,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('Pending', stats.pendingOrders.toString()),
              Container(
                height: 30,
                width: 1,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('Products', stats.activeProducts.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        Text(
          actionLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kAccentOrange,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: PhosphorIconsFill.plant,
                label: 'Catalog',
                subtitle: 'Ready-stock products',
                color: kPrimaryGreen,
                onTap: () => context.push(AppRouter.farmerProducts),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: PhosphorIconsFill.calendarCheck,
                label: 'Pre-orders',
                subtitle: 'Campaigns & reservations',
                color: kAccentOrange,
                onTap: () => context.push(AppRouter.farmerPreorders),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: kTextGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class _ActiveDropPointsCard extends ConsumerStatefulWidget {
  const _ActiveDropPointsCard();


  @override
  ConsumerState<_ActiveDropPointsCard> createState() => _ActiveDropPointsCardState();
}

class _ActiveDropPointsCardState extends ConsumerState<_ActiveDropPointsCard> {
  bool _isExpanded = false;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Branch'),
        content: const Text('Are you sure you want to delete this branch?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await ref.read(dropPointsControllerProvider.notifier).deleteDropPoint(id);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch deleted successfully')),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete branch'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropPointsState = ref.watch(dropPointsControllerProvider);

    return dropPointsState.maybeWhen(
      data: (dropPoints) {
        final hasDropPoints = dropPoints.isNotEmpty;
        final String dpName = hasDropPoints
            ? dropPoints.first.name
            : 'No Active Branches';
        final String dpSubtitle = hasDropPoints
            ? '${dropPoints.length} Branch(es) available'
            : 'Add a branch location';

        return Container(
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kPrimaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(PhosphorIconsFill.mapPin,
                          color: kPrimaryGreen, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: hasDropPoints
                            ? () => setState(() => _isExpanded = !_isExpanded)
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Branches (Drop Points)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kTextGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (hasDropPoints) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                      _isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: kTextGrey),
                                ]
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dpName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dpSubtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: kTextGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(AppRouter.editDropPoint);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(0, 36),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasDropPoints)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Container(
                    constraints: _isExpanded
                        ? const BoxConstraints(maxHeight: double.infinity)
                        : const BoxConstraints(maxHeight: 0.0),
                    child: Column(
                      children: dropPoints.map<Widget>((branch) {
                        return Container(
                          decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(PhosphorIconsFill.mapPin,
                                    color: Colors.orange, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      branch.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kDarkGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      branch.address ?? 'No address',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: kTextGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(PhosphorIconsRegular.pencilSimple,
                                    size: 20, color: kDarkGreen),
                                onPressed: () {
                                  context.push(AppRouter.editDropPoint,
                                      extra: branch);
                                },
                              ),
                              IconButton(
                                icon: const Icon(PhosphorIconsRegular.trash,
                                    size: 20, color: Colors.red),
                                onPressed: () => _confirmDelete(context, ref, branch.id),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      orElse: () => const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: CircularProgressIndicator(color: kDarkGreen)),
      ),
    );
  }
}

// Widget _buildSourcingRequestsBanner(BuildContext context) {
//   return GestureDetector(
//     onTap: () => context.push(AppRouter.farmerSourcingRequests),
//     child: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: kAccentOrange,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: kAccentOrange.withOpacity(0.2),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(PhosphorIconsFill.speakerHigh,
//                 color: Colors.white, size: 28),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Open Bulk Requests',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Find buyers looking for large quantities and place your bids.',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.arrow_forward_ios_rounded,
//               color: Colors.white, size: 16),
//         ],
//       ),
//     ),
//   );
// }

Widget _buildUrgentOrders(List<FarmerOrder> recentOrders) {
  if (recentOrders.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        children: [
          const Icon(PhosphorIconsRegular.checkCircle,
              size: 48, color: kDarkGreen),
          const SizedBox(height: 12),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kDarkGreen,
            ),
          ),
          Text(
            'No pending orders at the moment.',
            style: TextStyle(color: kTextGrey),
          ),
        ],
      ),
    );
  }

  return Column(
    children: recentOrders.map((order) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildOrderItem(
          customer: order.buyerName,
          items: order.items
              .map((i) => '${i.quantity}x ${i.productName}')
              .join(', '),
          time: order.deliveryMethod, // Or formatted date
          status: order.status,
          isReady: order.status.toLowerCase() == 'ready',
        ),
      );
    }).toList(),
  );
}

Widget _buildOrderItem({
  required String customer,
  required String items,
  required String time,
  required String status,
  bool isReady = false,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kBorderColor),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isReady ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            PhosphorIconsFill.package,
            color: isReady ? Colors.green : kAccentOrange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                items,
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
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isReady ? kDarkGreen : kAccentOrange,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: kTextGrey,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildHarvestTimeline() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: kCardBg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: kBorderColor),
    ),
    child: Column(
      children: [
        _buildTimelineItem(
          time: '09:00 AM',
          title: 'Morning Harvest',
          subtitle: 'Tomatoes & Basil',
          isCompleted: true,
        ),
        _buildTimelineItem(
          time: '01:30 PM',
          title: 'Farm Gate Pickup',
          subtitle: 'Customer: Alice (Order #832)',
          isActive: true,
        ),
        _buildTimelineItem(
          time: '04:00 PM',
          title: 'Wholesale Delivery',
          subtitle: 'City Market Drop-off',
          isLast: true,
        ),
      ],
    ),
  );
}

Widget _buildTimelineItem({
  required String time,
  required String title,
  required String subtitle,
  bool isCompleted = false,
  bool isActive = false,
  bool isLast = false,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 70,
        child: Text(
          time,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? kDarkGreen : kTextGrey,
            fontSize: 13,
          ),
        ),
      ),
      Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isCompleted
                  ? kDarkGreen
                  : isActive
                      ? kAccentOrange
                      : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isCompleted || isActive ? Colors.transparent : kBorderColor,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 40,
              color: isCompleted ? kDarkGreen : kBorderColor,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
        ],
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: kTextGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
