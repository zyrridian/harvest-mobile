import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _kDarkGreen = Color(0xFF1A2F25);

/// A data model for a single quick-action button.
class QuickAction {
  final String label;
  final String? emoji;
  final String? iconPath;
  final IconData? iconData;
  final String? badge;
  final bool isNewBadge;
  final VoidCallback onTap;

  const QuickAction({
    required this.label,
    this.emoji,
    this.iconPath,
    this.iconData,
    this.badge,
    this.isNewBadge = false,
    required this.onTap,
  });
}

/// Gojek-style 4×2 quick action grid.
class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionGrid({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Show max 8 items
    final displayActions = actions.take(8).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Wrap(
            spacing: isDesktop ? 24 : 12,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: displayActions.map((action) {
              return SizedBox(
                width: 75, // slightly smaller width to fit 4 on smaller phones
                child: _QuickActionButton(action: action),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final QuickAction action;
  const _QuickActionButton({required this.action});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        action.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Blob/circle icon container
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F8F4),
                    borderRadius: BorderRadius.circular(18),
                    // border: Border.all(color: const Color(0xFFE0E0E0), width: .5),
                  ),
                  child: Center(
                    child: action.iconPath != null
                        ? SvgPicture.asset(
                            action.iconPath!,
                            width: 40,
                            height: 40,
                          )
                        : action.iconData != null
                            ? Icon(action.iconData,
                                color: _kDarkGreen, size: 26)
                            : Text(
                                action.emoji ?? '',
                                style: const TextStyle(fontSize: 26),
                              ),
                  ),
                ),
                // Badge
                if (action.badge != null)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: action.isNewBadge
                          ? const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2)
                          : const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: action.isNewBadge
                            ? const Color(0xFFE86A33)
                            : const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        action.badge!,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _kDarkGreen,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
