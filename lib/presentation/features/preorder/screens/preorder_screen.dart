import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_controller.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_state.dart';
import 'package:harvest_app/features/users/presentation/providers/address_controller.dart';
import 'package:intl/intl.dart';

const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF2E4E20);
const kTextGreen = Color(0xFF1E3A20);
const kPillGrey = Color(0xFFF0F2F0);

class PreOrderScreen extends ConsumerStatefulWidget {
  const PreOrderScreen({super.key});

  @override
  ConsumerState<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends ConsumerState<PreOrderScreen>
    with SingleTickerProviderStateMixin {
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
    final state = ref.watch(preOrderControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Icon(Icons.chevron_left, color: kTextGreen),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Pre-Order Harvests',
          style: GoogleFonts.inter(
            color: kTextGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Icon(Icons.tune, color: kTextGreen),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kTextGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (data) {
          return CustomScrollView(
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: Container(
                  color: kDarkGreen,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UPCOMING THIS SEASON',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8CD867),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Reserve before\nit's harvested",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lock in the best price directly from farmers',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatColumn(
                              '${data.activeHarvests}', 'Active harvests'),
                          _buildStatColumn(
                              '${data.yourReservations}', 'Your reservations',
                              isHighlight: true),
                          _buildStatColumn(data.avgSavings, 'Avg. savings'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Tabs
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: kTextGreen,
                    unselectedLabelColor: Colors.grey[500],
                    indicatorColor: kTextGreen,
                    indicatorWeight: 3,
                    labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    unselectedLabelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.normal, fontSize: 13),
                    onTap: (index) {
                      ref
                          .read(preOrderControllerProvider.notifier)
                          .setTabIndex(index);
                    },
                    tabs: const [
                      Tab(text: 'Available'),
                      Tab(text: 'My Reservations'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Conditional rendering based on active tab
              if (data.selectedTabIndex == 0) ...[
                // Closing Soon Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Closing soon',
                          style: GoogleFonts.inter(
                            color: kTextGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'See all',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Harvest Cards
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: _buildHarvestCard(data.availableHarvests[index]),
                      );
                    },
                    childCount: data.availableHarvests.length,
                  ),
                ),
              ] else if (data.selectedTabIndex == 1) ...[
                // Your Active Reservations Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your active reservations',
                          style: GoogleFonts.inter(
                            color: kTextGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'See all',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Active Reservations List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: data.activeReservations.map((res) {
                          bool isLast = data.activeReservations.last == res;
                          return Column(
                            children: [
                              _buildReservationItem(res),
                              if (!isLast)
                                const Divider(
                                    height: 1,
                                    indent: 64,
                                    endIndent: 16,
                                    color: Color(0xFFEEEEEE)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Text(
                        'No completed reservations yet.',
                        style: GoogleFonts.inter(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // How pre-order works
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF7E5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFFD4A373), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How pre-order works',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8B5E34),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reserve a quantity before harvest. Pay a 20% deposit now — the rest on delivery. Cancel up to 7 days before harvest for a full refund.',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8B5E34),
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String value, String label,
      {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color:
                isHighlight ? const Color(0xFFE89A33) : const Color(0xFFD4A373),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildHarvestCard(PreOrderHarvest harvest) {
    Color bgColor = const Color(0xFFE8F3E8);
    if (harvest.title.contains('Strawberry')) bgColor = const Color(0xFFFDE8F1);
    if (harvest.title.contains('Salmon')) bgColor = const Color(0xFFE3F2FD);

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        final slug = harvest.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
        context.push('/product/$slug');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Top Area
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    harvest.imageUrl,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.white, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          '${harvest.daysLeft} days left',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: harvest.status == 'Almost full'
                          ? const Color(0xFFFDECE8)
                          : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (harvest.status == 'Almost full')
                          const Text('🔥', style: TextStyle(fontSize: 10)),
                        if (harvest.status == 'Almost full')
                          const SizedBox(width: 4),
                        Text(
                          harvest.status,
                          style: GoogleFonts.inter(
                            color: harvest.status == 'Almost full'
                                ? const Color(0xFFD94A38)
                                : const Color(0xFF15803D),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  harvest.title,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kTextGreen),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.account_circle,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${harvest.farmerName}  ·  ${harvest.distance}',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${harvest.bookedQuantity.toInt()} ${harvest.unit} booked of ${harvest.totalQuantity.toInt()} ${harvest.unit}',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      '${harvest.progressPercentage.toInt()}%',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kTextGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: harvest.progressPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF386824)),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatter
                                    .format(harvest.price)
                                    .replaceAll(',00', ''),
                                style: GoogleFonts.inter(
                                  color: kTextGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: ' /${harvest.unit}',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${harvest.remainingQuantity.toInt()} ${harvest.unit} remaining',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showReserveBottomSheet(context, harvest);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Reserve now',
                          style: GoogleFonts.inter(
                            color: kTextGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildReservationItem(PreOrderReservation reservation) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(reservation.imageUrl,
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reservation.title} · ${reservation.quantityStr}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kTextGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${reservation.farmerName} · Harvest in ${reservation.daysToHarvest} days',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: reservation.status == 'Confirmed'
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reservation.status,
              style: GoogleFonts.inter(
                color: reservation.status == 'Confirmed'
                    ? const Color(0xFF15803D)
                    : const Color(0xFFC2410C),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReserveBottomSheet(BuildContext context, PreOrderHarvest harvest) {
    int quantity = 1;
    String deliveryMethod = 'PICKUP';
    String? addressId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reserve ${harvest.title}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextGreen,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Quantity (${harvest.unit})',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kTextGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: kDarkGreen,
                      ),
                      Text(
                        '$quantity',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: quantity < harvest.remainingQuantity
                            ? () => setState(() => quantity++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: kDarkGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Delivery Method',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kTextGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => deliveryMethod = 'PICKUP'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: deliveryMethod == 'PICKUP'
                                  ? const Color(0xFFE8F3E8)
                                  : Colors.white,
                              border: Border.all(
                                color: deliveryMethod == 'PICKUP'
                                    ? kDarkGreen
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Pickup',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: deliveryMethod == 'PICKUP'
                                      ? kDarkGreen
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => deliveryMethod = 'DELIVERY'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: deliveryMethod == 'DELIVERY'
                                  ? const Color(0xFFE8F3E8)
                                  : Colors.white,
                              border: Border.all(
                                color: deliveryMethod == 'DELIVERY'
                                    ? kDarkGreen
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Delivery',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: deliveryMethod == 'DELIVERY'
                                      ? kDarkGreen
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (deliveryMethod == 'DELIVERY') ...[
                    const SizedBox(height: 24),
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, child) {
                        final addressState = ref.watch(addressControllerProvider);
                        return addressState.when(
                          initial: () => const Center(child: CircularProgressIndicator()),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (msg) => Text('Error loading addresses: $msg', style: const TextStyle(color: Colors.red)),
                          data: (addresses) {
                            if (addresses.isEmpty) {
                              return Text(
                                'No addresses found. Please add an address in your profile.',
                                style: GoogleFonts.inter(color: Colors.grey[600]),
                              );
                            }
                            
                            // Set default if none selected
                            if (addressId == null && addresses.isNotEmpty) {
                              final defaultAddr = addresses.firstWhere(
                                (a) => a.isPrimary,
                                orElse: () => addresses.first,
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  addressId = defaultAddr.addressId;
                                });
                              });
                            }

                            return DropdownButtonFormField<String>(
                              value: addressId,
                              hint: const Text('Select an address'),
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              items: addresses.map((addr) {
                                return DropdownMenuItem<String>(
                                  value: addr.addressId,
                                  child: Text(
                                    '${addr.label} - ${addr.fullAddress}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  addressId = val;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reserving ${harvest.title}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        
                        final success = await ref
                            .read(preOrderControllerProvider.notifier)
                            .reserveHarvest(
                              harvest,
                              quantity: quantity,
                              deliveryMethod: deliveryMethod,
                              addressId: addressId,
                            );
                            
                        if (mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reservation successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to reserve harvest.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Confirm Reservation',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
