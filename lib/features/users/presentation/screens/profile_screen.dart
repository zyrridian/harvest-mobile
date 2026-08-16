import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../core/utils/localization_extension.dart';
import '../../../../core/providers/language_provider.dart';
import '../providers/profile_controller.dart';
import 'favorite_products_screen.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_us_screen.dart';
import 'personal_information_screen.dart';
import 'language_selection_screen.dart';
import '../../../../core/widgets/web_constrained_box.dart';
// import '../../../shared_widgets/app_scaffold.dart'; // Can use Scaffold directly
// import '../../../../core/config/theme/app_colors.dart'; // Local constants used for demo

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final currentLanguage = ref.watch(currentLanguageNameProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          context.l10n.profile,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
        ),
      ),
      body: profileState.when(
        initial: () => const SizedBox(),
        loading: () => const Center(
          child: CircularProgressIndicator(color: kDarkGreen),
        ),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warningCircle,
                  size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text(
                error,
                style: TextStyle(color: kTextGrey),
              ),
            ],
          ),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.read(profileControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          backgroundColor: Colors.white,
          child: WebConstrainedBox(
            child: ListView(
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
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPillGrey,
                      border: Border.all(color: Colors.white, width: 4),
                      image: profile.avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(profile.avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: TextStyle(
                      color: kTextGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. SETTINGS SECTION
            // _buildSectionHeader(context.l10n.accountSettings),
            // const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: [
                  _buildModernMenuItem(
                    icon: PhosphorIconsRegular.user,
                    title: context.l10n.personalInformation,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: PhosphorIconsRegular.mapPin,
                    title: context.l10n.myAddresses,
                    onTap: () => context.push(AppRouter.addresses),
                  ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: PhosphorIconsRegular.heart,
                    title: 'Favorite Products', // Or localized
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteProductsScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  // _buildModernMenuItem(
                  //   icon: PhosphorIconsRegular.clipboardText,
                  //   title: 'My Bulk Requests',
                  //   onTap: () => context.push(AppRouter.buyerSourcingRequests),
                  // ),
                  // _buildDivider(),
                  // _buildModernMenuItem(
                  //   icon: PhosphorIconsRegular.bell,
                  //   title: context.l10n.notifications,
                  //   onTap: () => context.push(AppRouter.notifications),
                  // ),
                  // _buildDivider(),
                  // _buildModernMenuItem(
                  //   icon: PhosphorIconsRegular.shieldCheck,
                  //   title: context.l10n.security,
                  //   onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const SecurityScreen(),
                  //     ),
                  //   ),
                  // ),
                  _buildDivider(),
                  _buildModernMenuItem(
                    icon: PhosphorIconsRegular.globe,
                    title: context.l10n.language,
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

            // // 4. SUPPORT SECTION
            // _buildSectionHeader(context.l10n.support),
            // const SizedBox(height: 12),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: kPillGrey),
            //   ),
            //   child: Column(
            //     children: [
            //       _buildModernMenuItem(
            //         icon: PhosphorIconsRegular.question,
            //         title: context.l10n.helpCenter,
            //         onTap: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const HelpCenterScreen(),
            //           ),
            //         ),
            //       ),
            //       _buildDivider(),
            //       _buildModernMenuItem(
            //         icon: PhosphorIconsRegular.shield,
            //         title: context.l10n.privacyPolicy,
            //         onTap: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const PrivacyPolicyScreen(),
            //           ),
            //         ),
            //       ),
            //       _buildDivider(),
            //       _buildModernMenuItem(
            //         icon: PhosphorIconsRegular.info,
            //         title: context.l10n.aboutUs,
            //         onTap: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const AboutUsScreen(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // const SizedBox(height: 32),

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
                  context.l10n.logout,
                  style: TextStyle(
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
                context.l10n.version,
                style: TextStyle(color: kTextGrey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
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
        style: TextStyle(
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
              PhosphorIcon(icon, color: kDarkGreen, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
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
                    style: TextStyle(color: kTextGrey, fontSize: 13),
                  ),
                ),
              PhosphorIcon(PhosphorIconsRegular.caretRight,
                  color: kPillGrey, size: 20),
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
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.logout,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          context.l10n.logoutConfirm,
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child:
                Text(context.l10n.cancel, style: TextStyle(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close dialog

              // Show loading indicator
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) => const Center(
                    child: CircularProgressIndicator(color: kDarkGreen),
                  ),
                );
              }

              // Actually logout the user
              await ref.read(authControllerProvider.notifier).logout();

              // Close loading dialog and navigate to login
              if (context.mounted) {
                Navigator.of(context).pop(); // Close loading
                // Use go to navigate to login and clear stack
                context.go(AppRouter.roleSelection);
              }
            },
            child: Text(
              context.l10n.logout,
              style: TextStyle(
                  color: const Color(0xFFDC2626), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
