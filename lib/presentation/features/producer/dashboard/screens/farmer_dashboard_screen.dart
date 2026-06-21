import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFF7F9F8);
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
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Urgent Orders', 'View all'),
            const SizedBox(height: 16),
            _buildUrgentOrders(),
            const SizedBox(height: 32),
            _buildSectionHeader('Today\'s Harvest Pickups', 'Schedule'),
            const SizedBox(height: 16),
            _buildHarvestTimeline(),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kBgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: GoogleFonts.inter(
              color: kTextGrey,
              fontSize: 14,
            ),
          ),
          Text(
            'Green Valley Farm',
            style: GoogleFonts.inter(
              color: kDarkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Stack(
            children: [
              const Icon(PhosphorIconsRegular.bell, color: kDarkGreen),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kAccentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildRevenueCard() {
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
                'Today\'s Revenue',
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(PhosphorIconsFill.trendUp, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: GoogleFonts.inter(
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
            '\$1,250.00',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem('Orders', '18'),
              Container(
                height: 30,
                width: 1,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('Pending', '3'),
              Container(
                height: 30,
                width: 1,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('Pickups', '5'),
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
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
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
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        Text(
          actionLabel,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kAccentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgentOrders() {
    return Column(
      children: [
        _buildOrderItem(
          customer: 'Sarah Jenkins',
          items: '2x Organic Tomatoes, 1x Kale',
          time: 'in 2 hours',
          status: 'Awaiting Pack',
        ),
        const SizedBox(height: 12),
        _buildOrderItem(
          customer: 'Michael Scott',
          items: '5kg Fresh Potatoes',
          time: 'in 3 hours',
          status: 'Awaiting Pack',
        ),
        const SizedBox(height: 12),
        _buildOrderItem(
          customer: 'Fresh Foods Market',
          items: '10x Wholesale Carrots',
          time: 'Today, 4:00 PM',
          status: 'Ready',
          isReady: true,
        ),
      ],
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items,
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isReady ? kDarkGreen : kAccentOrange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: GoogleFonts.inter(
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
            style: GoogleFonts.inter(
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
                  color: isCompleted || isActive ? Colors.transparent : kBorderColor,
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
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
}
