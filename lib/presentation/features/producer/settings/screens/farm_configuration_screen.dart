import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:go_router/go_router.dart';
import '../../../../../features/auth/presentation/providers/auth_controller.dart';
import '../providers/farmer_settings_controller.dart';
import '../../../../../domain/entities/farmer_profile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class FarmConfigurationScreen extends ConsumerWidget {
  const FarmConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(farmerSettingsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          'Farm Settings',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
        ),
      ),
      body: settingsState.maybeWhen(
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
                error.toString(),
                style: const TextStyle(color: kTextGrey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(farmerSettingsControllerProvider.notifier)
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile, deliverySettings) => RefreshIndicator(
          onRefresh: () =>
              ref.read(farmerSettingsControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // 1. PROFILE HEADER CARD
              _buildProfileSection(profile),
              const SizedBox(height: 24),

              // 2. SETTINGS SECTION
              _buildSectionHeader('Farm Configuration'),
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
                      icon: PhosphorIconsRegular.storefront,
                      title: 'Edit Farm Profile',
                      onTap: () => context.push(AppRouter.editFarmProfile),
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.image,
                      title: 'Manage Gallery',
                      onTap: () => context.push(AppRouter.manageGallery),
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.star,
                      title: 'My Farm Reviews',
                      onTap: () => context.push(AppRouter.farmReviews),
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.wallet,
                      title: 'Wallet & Earnings',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.mapTrifold,
                      title: 'Manage Drop Points',
                      onTap: () => context.push(AppRouter.dropPoints),
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.truck,
                      title: 'Delivery Settings',
                      onTap: () => context.push(AppRouter.deliverySettings),
                    ),
                    _buildDivider(),
                    _buildModernMenuItem(
                      icon: PhosphorIconsRegular.gear,
                      title: 'Account Settings',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 3. LOGOUT BUTTON
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
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFDC2626), // Dark Red
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildProfileSection(FarmerProfile profile) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              color: kPillGrey,
              image: profile.coverImage != null
                  ? DecorationImage(
                      image: NetworkImage(profile.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // Profile Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Profile Avatar overlapping banner
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: kPillGrey,
                      image: profile.profileImage != null
                          ? DecorationImage(
                              image: NetworkImage(profile.profileImage!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kDarkGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (profile.isVerified)
                          Row(
                            children: [
                              const PhosphorIcon(PhosphorIconsFill.sealCheck,
                                  color: Color(0xFF3B82F6), size: 14),
                              const SizedBox(width: 4),
                              const Text(
                                'Verified Farmer',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Location Text
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                const PhosphorIcon(PhosphorIconsRegular.navigationArrow,
                    color: kTextGrey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    [profile.city, profile.state]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(', '),
                    style: const TextStyle(
                      color: kTextGrey,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
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
                  style: const TextStyle(
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
                    style: const TextStyle(color: kTextGrey, fontSize: 13),
                  ),
                ),
              const PhosphorIcon(PhosphorIconsRegular.caretRight,
                  color: kPillGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, thickness: 1, color: kPillGrey, indent: 58, endIndent: 20);
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
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
                context.go(AppRouter.roleSelection);
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                  color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
