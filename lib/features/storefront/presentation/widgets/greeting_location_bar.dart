import 'package:flutter/material.dart';

const _kDarkGreen = Color(0xFF1A2F25);
const _kSage = Color(0xFF7C9070);
const _kTerra = Color(0xFFE86A33);
const _kSand = Color(0xFFF0EAD6);

class GreetingLocationBar extends StatelessWidget {
  final String? userName;
  final String? locationName;
  final VoidCallback? onLocationTap;

  const GreetingLocationBar({
    super.key,
    this.userName,
    this.locationName,
    this.onLocationTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '🌅';
    if (hour < 17) return '☀️';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _kSand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, ${userName ?? 'Farmer'}! ${_getGreetingEmoji()}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _kDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'What are you looking for today?',
                  style: TextStyle(
                    fontSize: 12,
                    color: _kSage,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Location chip
          GestureDetector(
            onTap: onLocationTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: _kTerra.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 13, color: _kTerra),
                  const SizedBox(width: 4),
                  Text(
                    locationName ?? 'Set location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _kTerra,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 14, color: _kTerra),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
