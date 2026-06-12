import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/features/farmers/screens/farmers_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../harvest/screens/harvest_screen.dart';
import '../../order/screens/orders_list_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../community/screens/community_screen.dart';

// Provider to manage which tab is active
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Track visibility internally to avoid global rebuilds for scrolling
  bool _isNavVisible = true;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = [
      const HomeScreen(),
      const HarvestScreen(),
      const CommunityScreen(),
      const FarmersScreen(),
      const OrdersListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) =>
                ref.read(bottomNavIndexProvider.notifier).state = index,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF166534),
            unselectedItemColor: Colors.grey.shade600,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.house),
              activeIcon: Icon(PhosphorIconsFill.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.bookOpen),
              activeIcon: Icon(PhosphorIconsFill.bookOpen),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.users),
              activeIcon: Icon(PhosphorIconsFill.users),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.plant),
              activeIcon: Icon(PhosphorIconsFill.plant),
              label: 'Farmers',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.receipt),
              activeIcon: Icon(PhosphorIconsFill.receipt),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.user),
              activeIcon: Icon(PhosphorIconsFill.user),
              label: 'Profile',
            ),
          ],
          ),
        ),
      ),
    );
  }
}
