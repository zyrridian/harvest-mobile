import 'package:flutter/material.dart';
import 'package:harvest_app/presentation/providers/messaging_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/screens/farmer_dashboard_screen.dart';
import '../../products/screens/farmer_product_screen.dart';
import '../../orders/screens/order_tracking_screen.dart';
import '../../settings/screens/farm_configuration_screen.dart';
import '../../../../../features/community/presentation/screens/conversations_list_screen.dart';
import '../../../../../features/community/presentation/providers/chat_socket_providers.dart';

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
      const FarmerProductScreen(),
      const OrderTrackingScreen(),
      const ConversationsListScreen(),
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
