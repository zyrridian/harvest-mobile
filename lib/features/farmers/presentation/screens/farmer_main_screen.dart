import 'package:flutter/material.dart';
import 'package:harvest_app/features/farmers/presentation/screens/settings/farm_configuration_screen.dart';
import 'package:harvest_app/features/chat/presentation/providers/messaging_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/responsive_layout.dart';

import 'farmer_dashboard_screen.dart';

import '../../../sales/presentation/screens/farmer_order_list_screen.dart';
import '../../../community/presentation/screens/conversations_list_screen.dart';
import '../../../community/presentation/providers/chat_socket_providers.dart';
import '../../../community/presentation/screens/community_screen.dart';

// Provider to manage which tab is active for the farmer
final farmerBottomNavIndexProvider = StateProvider<int>((ref) => 0);

class FarmerMainScreen extends ConsumerStatefulWidget {
  const FarmerMainScreen({super.key});

  @override
  ConsumerState<FarmerMainScreen> createState() => _FarmerMainScreenState();
}

class _FarmerMainScreenState extends ConsumerState<FarmerMainScreen> {
  @override
  void initState() {
    super.initState();
    // Connect to chat socket globally so we receive typing/online events everywhere
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(connectChatSocketProvider).connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(farmerBottomNavIndexProvider);

    final screens = [
      const FarmerDashboardScreen(),
      const FarmerOrderListScreen(),
      const CommunityScreen(),
      const ConversationsListScreen(),
      const FarmConfigurationScreen(),
    ];

    final mobileBody = Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _FarmerBottomNav(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(farmerBottomNavIndexProvider.notifier).state = i,
      ),
    );

    final desktopBody = Scaffold(
      body: Row(
        children: [
          _FarmerSideNav(
            currentIndex: currentIndex,
            onTap: (i) => ref.read(farmerBottomNavIndexProvider.notifier).state = i,
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

// ─── Custom Bottom Navigation Bar ────────────────────────────────────────────

class _FarmerBottomNav extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FarmerBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(newMessageStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });
    ref.listen(readAckStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });

    final providerParams = (filter: 'all', search: null, page: 1, limit: 20);

    final conversationsAsync = ref.watch(conversationsProvider(providerParams));

    final data = conversationsAsync.valueOrNull;
    final stats = data?['data']?['stats'] as Map<String, dynamic>?;
    final int unreadCount = stats?['unread_conversations'] as int? ?? 0;

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
                label: 'Orders',
                activeIcon: PhosphorIconsFill.receipt,
                inactiveIcon: PhosphorIconsRegular.receipt,
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                label: 'Community',
                activeIcon: PhosphorIconsFill.users,
                inactiveIcon: PhosphorIconsRegular.users,
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                label: 'Chat',
                activeIcon: PhosphorIconsFill.chatCircleText,
                inactiveIcon: PhosphorIconsRegular.chatCircleText,
                onTap: onTap,
                showBadge: unreadCount > 0,
              ),
              _NavItem(
                index: 4,
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
  final bool showBadge;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    const activeColor = Color(0xFF1A2F25); // Matching main app theme
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
                child: Badge(
                  isLabelVisible: showBadge,
                  backgroundColor: Colors.red,
                  smallSize: 8,
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive ? activeColor : inactiveColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
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

// ─── Custom Side Navigation Bar (Web/Desktop) ────────────────────────────────

class _FarmerSideNav extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FarmerSideNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(newMessageStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });
    ref.listen(readAckStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });

    final providerParams = (filter: 'all', search: null, page: 1, limit: 20);

    final conversationsAsync = ref.watch(conversationsProvider(providerParams));

    final data = conversationsAsync.valueOrNull;
    final stats = data?['data']?['stats'] as Map<String, dynamic>?;
    final int unreadCount = stats?['unread_conversations'] as int? ?? 0;

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
            label: 'Dashboard',
            activeIcon: PhosphorIconsFill.squaresFour,
            inactiveIcon: PhosphorIconsRegular.squaresFour,
            onTap: onTap,
          ),
          _SideNavItem(
            index: 1,
            currentIndex: currentIndex,
            label: 'Orders',
            activeIcon: PhosphorIconsFill.receipt,
            inactiveIcon: PhosphorIconsRegular.receipt,
            onTap: onTap,
          ),
          _SideNavItem(
            index: 2,
            currentIndex: currentIndex,
            label: 'Community',
            activeIcon: PhosphorIconsFill.users,
            inactiveIcon: PhosphorIconsRegular.users,
            onTap: onTap,
          ),
          _SideNavItem(
            index: 3,
            currentIndex: currentIndex,
            label: 'Chat',
            activeIcon: PhosphorIconsFill.chatCircleText,
            inactiveIcon: PhosphorIconsRegular.chatCircleText,
            onTap: onTap,
            showBadge: unreadCount > 0,
          ),
          _SideNavItem(
            index: 4,
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
  final bool showBadge;

  const _SideNavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    this.showBadge = false,
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
            Badge(
              isLabelVisible: showBadge,
              backgroundColor: Colors.red,
              smallSize: 8,
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? activeColor : inactiveColor,
                size: 22,
              ),
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
