import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/screens/home_screen.dart';
import '../../harvest/screens/harvest_screen.dart';
import '../../farmers/screens/farmers_screen.dart';
import '../../profile/screens/profile_screen.dart';

// --- DESIGN CONSTANTS ---
const kNavBgColor = Color(0xFF1A2F25); // Dark Forest Green
final kNavOverlayColor =
    Colors.white.withOpacity(0.15); // Subtle selection overlay

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
      const FarmersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true, // IMPORTANT: Allows content to be behind the nav bar

      // 1. SCROLL LISTENER
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse &&
              _isNavVisible) {
            // Scrolling Down -> Hide
            setState(() => _isNavVisible = false);
          } else if (notification.direction == ScrollDirection.forward &&
              !_isNavVisible) {
            // Scrolling Up -> Show
            setState(() => _isNavVisible = true);
          }
          return true;
        },
        child: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
      ),

      // 2. ANIMATED SLIDE (Fixes the "Push Down" issue)
      // Instead of changing height (which shifts layout), we just translate it Y-axis.
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        offset: _isNavVisible
            ? Offset.zero
            : const Offset(0, 2), // Slide down 200% to hide
        child: SafeArea(
          top: false,
          child: Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24), // Float margins
            decoration: BoxDecoration(
              color: kNavBgColor,
              borderRadius: BorderRadius.circular(35), // Parent Radius (Pill)
              boxShadow: [
                BoxShadow(
                  color: kNavBgColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    currentIndex: currentIndex),
                _buildNavItem(
                    index: 1,
                    icon: Icons.school_outlined,
                    label: 'Learn',
                    currentIndex: currentIndex),
                _buildNavItem(
                    index: 2,
                    icon: Icons.people_outline_rounded,
                    label: 'Farmers',
                    currentIndex: currentIndex),
                _buildNavItem(
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    currentIndex: currentIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required int currentIndex,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(bottomNavIndexProvider.notifier).state = index,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 56, // Fits nicely inside the 70px parent
            width: isSelected ? 80 : 50, // Grows when selected
            decoration: BoxDecoration(
              color: isSelected ? kNavOverlayColor : Colors.transparent,
              borderRadius: BorderRadius.circular(35), // Matches parent radius
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  // Pure white if selected, faded if not
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  // Optional: Show faded label or nothing
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
