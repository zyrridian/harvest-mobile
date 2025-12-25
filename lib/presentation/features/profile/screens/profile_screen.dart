import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../providers/profile_providers.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_us_screen.dart';
import 'personal_information_screen.dart';
import 'security_screen.dart';
import 'language_selection_screen.dart';
// import '../../../shared_widgets/app_scaffold.dart'; // Can use Scaffold directly
// import '../../../../core/config/theme/app_colors.dart'; // Local constants used for demo

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // 1. PROFILE HEADER CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kPillGrey),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPillGrey,
                          border: Border.all(color: Colors.white, width: 4),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://i.pravatar.cc/300'), // Replace with actual user image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kDarkGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit,
                            size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: GoogleFonts.dmSans(
                      color: kTextGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PersonalInformationScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkGreen,
                      side: const BorderSide(color: kPillGrey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. PREMIUM SUBSCRIPTION CARD
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2D4A3E),
                    Color(0xFF1A2F25)
                  ], // Dark Green Gradient
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(AppRouter.subscriptionIntro),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.workspace_premium_rounded,
                              color: Color(0xFFFFD700), size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harvest Premium',
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Free delivery & exclusive deals',
                                style: GoogleFonts.dmSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 3. SETTINGS SECTION
            _buildSectionHeader('Account Settings'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: [
                  _buildModernMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () => context.push(AppRouter.addresses),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => context.push(AppRouter.notifications),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecurityScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.language,
                    title: 'Language',
                    trailingText: currentLanguage,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageSelectionScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. SUPPORT SECTION
            _buildSectionHeader('Support'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: [
                  _buildModernMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 5. LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _showLogoutDialog(context, ref),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFFEE2E2), // Light Red
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Log Out',
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFFDC2626), // Dark Red
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: kDarkGreen),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text(
                'Error loading profile',
                style: GoogleFonts.dmSans(color: kTextGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kTextGrey,
        ),
      ),
    );
  }

  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: kDarkGreen, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kDarkGreen,
                  ),
                ),
              ),
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    trailingText,
                    style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 13),
                  ),
                ),
              Icon(Icons.chevron_right_rounded, color: kPillGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1, thickness: 1, color: kPillGrey, indent: 58, endIndent: 20);
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.dmSans(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.login);
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.dmSans(
                  color: const Color(0xFFDC2626), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
