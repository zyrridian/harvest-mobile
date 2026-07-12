import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PillTabItem {
  final String name;
  final IconData? icon;

  const PillTabItem({required this.name, this.icon});
}

class PillTabBar extends StatelessWidget {
  final List<PillTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color activeColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const PillTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.activeColor = const Color(0xFF1A2F25), // kDarkGreen
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = const Color(0xFF1A2F25),
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor, // Solid background for sticky header
      height: 52, // Content height 36 + padding 16
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.white,
                border: Border.all(
                  color: isSelected ? activeColor : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.icon != null) ...[
                    PhosphorIcon(
                      tab.icon!,
                      size: 14,
                      color: isSelected ? activeTextColor : inactiveTextColor,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    tab.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? activeTextColor : inactiveTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PillTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  PillTabBarDelegate({
    required this.child,
    this.height = 52.0,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(PillTabBarDelegate oldDelegate) {
    return true;
  }
}
