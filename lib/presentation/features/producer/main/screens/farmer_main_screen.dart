import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dashboard/screens/farmer_dashboard_screen.dart';
import '../../products/screens/product_management_screen.dart';
import '../../orders/screens/order_tracking_screen.dart';
import '../../settings/screens/farm_configuration_screen.dart';

// Provider to manage which tab is active for the farmer
final farmerBottomNavIndexProvider = StateProvider<int>((ref) => 0);

class FarmerMainScreen extends ConsumerWidget {
  const FarmerMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(farmerBottomNavIndexProvider);

    final screens = [
      const FarmerDashboardScreen(),
      const ProductManagementScreen(),
      const OrderTrackingScreen(),
      const FarmConfigurationScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _FarmerBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(farmerBottomNavIndexProvider.notifier).state = i,
      ),
    );
  }
}

// ─── Custom Bottom Navigation Bar ────────────────────────────────────────────

class _FarmerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FarmerBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                label: 'Dashboard',
                activeIcon: PhosphorIconsFill.squaresFour,
                inactiveIcon: PhosphorIconsRegular.squaresFour,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                label: 'Products',
                activeIcon: PhosphorIconsFill.leaf,
                inactiveIcon: PhosphorIconsRegular.leaf,
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                label: 'Orders',
                activeIcon: PhosphorIconsFill.receipt,
                inactiveIcon: PhosphorIconsRegular.receipt,
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                label: 'Settings',
                activeIcon: PhosphorIconsFill.gear,
                inactiveIcon: PhosphorIconsRegular.gear,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    const activeColor = Color(0xFF2D4A3E); // Slightly different green for farmers
    const inactiveColor = Color(0xFF9CA3AF);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with animated background pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: isActive ? 18 : 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? activeColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isActive ? activeIcon : inactiveIcon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
