import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
// import 'package:harvest_app/core/config/router/app_router.dart';

// Constants
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

class SubscriptionIntroScreen extends ConsumerWidget {
  const SubscriptionIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO SECTION
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: kPillGrey, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: kDarkGreen.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.autorenew_rounded,
                          size: 80, color: kDarkGreen.withOpacity(0.1)),
                      const Icon(Icons.local_shipping_outlined,
                          size: 60, color: kDarkGreen),
                      Positioned(
                        right: 20,
                        bottom: 40,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: kAccentOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '-15%',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Subscribe & Save',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Get fresh produce delivered regularly. Save money and never run out of your essentials.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF6E7A75),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // 2. BENEFITS GRID
              Text('Why Subscribe?',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen)),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _buildBenefitCard(Icons.savings_outlined, 'Save 15%',
                      'On every order', Colors.orange),
                  _buildBenefitCard(Icons.calendar_today_outlined, 'Flexible',
                      'Skip or pause', Colors.blue),
                  _buildBenefitCard(Icons.eco_outlined, 'Support Local',
                      'Direct from farms', Colors.green),
                  _buildBenefitCard(Icons.edit_outlined, 'Modify',
                      'Easy changes', Colors.purple),
                ],
              ),

              const SizedBox(height: 40),

              // 3. STEPS
              Text('How It Works',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen)),
              const SizedBox(height: 20),
              _buildStepRow(
                  '1', 'Choose Products', 'Select your favorite fresh items'),
              _buildStepLine(),
              _buildStepRow(
                  '2', 'Set Schedule', 'Weekly, bi-weekly, or monthly'),
              _buildStepLine(),
              _buildStepRow('3', 'Relax', 'Automatic delivery to your door'),

              const SizedBox(height: 40),

              // CTA
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Create Subscription',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.push(AppRouter.subscriptions);
                  },
                  child: Text(
                    'View My Subscriptions',
                    style: GoogleFonts.inter(
                        color: kDarkGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard(
      IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPillGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: kDarkGreen)),
          Text(sub,
              style: GoogleFonts.inter(
                  fontSize: 12, color: const Color(0xFF6E7A75))),
        ],
      ),
    );
  }

  Widget _buildStepRow(String num, String title, String desc) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: kDarkGreen, shape: BoxShape.circle),
          child: Center(
              child: Text(num,
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, color: kDarkGreen)),
              Text(desc,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: const Color(0xFF6E7A75))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 4, bottom: 4),
      height: 20,
      width: 2,
      color: kPillGrey,
    );
  }
}
