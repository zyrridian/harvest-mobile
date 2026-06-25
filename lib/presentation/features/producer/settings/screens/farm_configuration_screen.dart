import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_controller.dart';
import '../providers/farmer_settings_controller.dart';
import '../../../../../domain/entities/farmer_profile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class FarmConfigurationScreen extends ConsumerWidget {
  const FarmConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(farmerSettingsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: settingsState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(farmerSettingsControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile, deliverySettings) => RefreshIndicator(
          onRefresh: () => ref.read(farmerSettingsControllerProvider.notifier).refresh(),
          color: kDarkGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMapLocationSection(profile),
                const SizedBox(height: 24),
                Text(
                  'Farm Configuration',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsList(context, ref, profile),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildMapLocationSection(FarmerProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Farm Location',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kDarkGreen,
                  ),
                ),
                Text(
                  'Edit',
                  style: GoogleFonts.inter(
                    color: kAccentOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Mock Map Area
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(PhosphorIconsFill.mapPin, color: kAccentOrange, size: 32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(PhosphorIconsRegular.navigationArrow, color: kTextGrey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    profile.address,
                    style: GoogleFonts.inter(
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

  Widget _buildSettingsList(BuildContext context, WidgetRef ref, FarmerProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: PhosphorIconsRegular.storefront,
            title: 'Edit Farm Profile',
            subtitle: profile.name,
            onTap: () => context.push(AppRouter.editFarmProfile),
          ),
          const Divider(height: 1, color: kBorderColor),
          _buildSettingsTile(
            icon: PhosphorIconsRegular.star,
            title: 'My Farm Reviews',
            subtitle: 'See what buyers are saying',
            onTap: () => context.push(AppRouter.farmReviews),
          ),
          const Divider(height: 1, color: kBorderColor),
          _buildSettingsTile(
            icon: PhosphorIconsRegular.wallet,
            title: 'Wallet & Earnings',
            subtitle: 'Manage your payouts and transactions',
          ),
          const Divider(height: 1, color: kBorderColor),
          _buildSettingsTile(
            icon: PhosphorIconsRegular.mapTrifold,
            title: 'Manage Drop Points',
            subtitle: 'Set pickup locations for consumers',
          ),
          const Divider(height: 1, color: kBorderColor),
          _buildSettingsTile(
            icon: PhosphorIconsRegular.truck,
            title: 'Delivery Settings',
            subtitle: 'Configure wholesale delivery radius',
          ),
          const Divider(height: 1, color: kBorderColor),
          _buildSettingsTile(
            icon: PhosphorIconsRegular.gear,
            title: 'Account Settings',
            subtitle: 'Password, notifications, and language',
          ),
          const Divider(height: 1, color: kBorderColor),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(PhosphorIconsRegular.signOut, color: Colors.red),
            ),
            title: Text(
              'Log Out',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            trailing: const Icon(PhosphorIconsRegular.caretRight, color: kTextGrey, size: 16),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRouter.roleSelection);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: kDarkGreen),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: kDarkGreen,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          color: kTextGrey,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(PhosphorIconsRegular.caretRight, color: kTextGrey, size: 16),
      onTap: onTap,
    );
  }
}
