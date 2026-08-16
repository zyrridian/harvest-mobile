import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../users/presentation/screens/profile_screen.dart';
import '../../../explore/presentation/screens/explore_screen.dart';
import '../../../../core/widgets/responsive_layout.dart';

// Provider to manage which tab is active
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = [
      const HomeScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    final mobileBody = Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _HarvestBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
      ),
    );

    final desktopBody = Scaffold(
      body: Row(
        children: [
          _HarvestSideNav(
            currentIndex: currentIndex,
            onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
          ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
    );

    return ResponsiveLayout(
      mobileBody: mobileBody,
      desktopBody: desktopBody,
    );
  }
}

// ─── Custom Bottom Navigation Bar (Mobile) ───────────────────────────────────

class _HarvestBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _HarvestBottomNav({
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
                label: 'Home',
                activeIcon: PhosphorIconsFill.house,
                inactiveIcon: PhosphorIconsRegular.house,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                label: 'Community',
                activeIcon: PhosphorIconsFill.users,
                inactiveIcon: PhosphorIconsRegular.users,
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                label: 'Profile',
                activeIcon: PhosphorIconsFill.user,
                inactiveIcon: PhosphorIconsRegular.user,
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
    const activeColor = Color(0xFF1A2F25);
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
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
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

// ─── Custom Side Navigation Bar (Web/Desktop) ────────────────────────────────

class _HarvestSideNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _HarvestSideNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // App Logo / Title here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const PhosphorIcon(PhosphorIconsFill.plant,
                    color: Color(0xFF1A2F25), size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Harvest',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2F25),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _SideNavItem(
            index: 0,
            currentIndex: currentIndex,
            label: 'Home',
            activeIcon: PhosphorIconsFill.house,
            inactiveIcon: PhosphorIconsRegular.house,
            onTap: onTap,
          ),
          _SideNavItem(
            index: 1,
            currentIndex: currentIndex,
            label: 'Community',
            activeIcon: PhosphorIconsFill.users,
            inactiveIcon: PhosphorIconsRegular.users,
            onTap: onTap,
          ),
          _SideNavItem(
            index: 2,
            currentIndex: currentIndex,
            label: 'Profile',
            activeIcon: PhosphorIconsFill.user,
            inactiveIcon: PhosphorIconsRegular.user,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final ValueChanged<int> onTap;

  const _SideNavItem({
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
    const activeColor = Color(0xFF1A2F25);
    const inactiveColor = Color(0xFF9CA3AF);

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
