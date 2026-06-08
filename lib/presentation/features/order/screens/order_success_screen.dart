import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router/app_router.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class OrderSuccessScreen extends StatelessWidget {
  static const routeName = '/order-success';
  final String orderId;
  final String orderNumber;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Animation or Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: kDarkGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: kDarkGreen,
                  size: 80,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              Text(
                'Order Placed!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Order Number
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: kPillGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Order #$orderNumber',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                'Thank you for your order!\nWe\'ll notify you when it\'s on the way.',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: kTextGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('${AppRouter.orderDetail}?orderId=$orderId');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'View Order Details',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    context.go(AppRouter.main);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kDarkGreen,
                    side: const BorderSide(color: kDarkGreen, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  context.go(AppRouter.orders);
                },
                child: Text(
                  'View All Orders',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: kTextGrey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
