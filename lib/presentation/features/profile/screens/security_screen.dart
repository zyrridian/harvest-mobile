import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/profile_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final securityAsync = ref.watch(securitySettingsProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Security',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
      ),
      body: securityAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Security Settings Section
            _buildSectionTitle('Security Settings'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security',
                    icon: Icons.security_outlined,
                    value: settings.twoFactorEnabled,
                    onChanged: (value) => _updateTwoFactor(value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Biometric Login',
                    subtitle: 'Use fingerprint or face recognition',
                    icon: Icons.fingerprint,
                    value: settings.biometricEnabled,
                    onChanged: (value) => _updateBiometric(value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Email Notifications',
                    subtitle: 'Get notified of security events',
                    icon: Icons.mail_outline,
                    value: settings.emailNotificationsEnabled,
                    onChanged: (value) => _updateEmailNotifications(value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Password Section
            _buildSectionTitle('Password'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    title: 'Change Password',
                    subtitle: settings.lastPasswordChange != null
                        ? 'Last changed ${_formatDate(settings.lastPasswordChange!)}'
                        : 'Never changed',
                    icon: Icons.lock_outline,
                    onTap: () => _showChangePasswordDialog(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Active Sessions Section
            _buildSectionTitle('Active Sessions'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                children: settings.activeSessions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final session = entry.value;
                  return Column(
                    children: [
                      if (index > 0) _buildDivider(),
                      _buildSessionTile(session),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Danger Zone
            _buildSectionTitle('Danger Zone'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: const Color(0xFFDC2626), size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Delete Account',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Permanently delete your account and all associated data. This action cannot be undone.',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showDeleteAccountDialog(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Delete My Account',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading security settings',
            style: GoogleFonts.dmSans(color: kTextGrey),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kDarkGreen, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: kTextGrey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kDarkGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kDarkGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: kDarkGreen, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: kPillGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTile(String sessionName) {
    final isCurrent = sessionName.contains('Current');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrent
                  ? kDarkGreen.withOpacity(0.1)
                  : kTextGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCurrent ? Icons.phone_android : Icons.devices,
              color: isCurrent ? kDarkGreen : kTextGrey,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionName,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'This device',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () => _terminateSession(sessionName),
              child: Text(
                'Terminate',
                style: GoogleFonts.dmSans(
                  color: const Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: kPillGrey,
      indent: 20,
      endIndent: 20,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _updateTwoFactor(bool enabled) async {
    final updateTwoFactor = ref.read(updateTwoFactorProvider);
    try {
      await updateTwoFactor(enabled);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Two-factor authentication ${enabled ? "enabled" : "disabled"}',
              style: GoogleFonts.dmSans(),
            ),
            backgroundColor: kDarkGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update setting', style: GoogleFonts.dmSans()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateBiometric(bool enabled) async {
    final updateBiometric = ref.read(updateBiometricProvider);
    try {
      await updateBiometric(enabled);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Biometric login ${enabled ? "enabled" : "disabled"}',
              style: GoogleFonts.dmSans(),
            ),
            backgroundColor: kDarkGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update setting', style: GoogleFonts.dmSans()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateEmailNotifications(bool enabled) async {
    final repository = ref.read(securitySettingsRepositoryProvider);
    try {
      await repository.updateEmailNotifications(enabled);
      ref.invalidate(securitySettingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email notifications ${enabled ? "enabled" : "disabled"}',
              style: GoogleFonts.dmSans(),
            ),
            backgroundColor: kDarkGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update setting', style: GoogleFonts.dmSans()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _terminateSession(String sessionName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Terminate Session',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to terminate this session?',
          style: GoogleFonts.dmSans(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Terminate',
              style: GoogleFonts.dmSans(
                color: const Color(0xFFDC2626),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final terminateSession = ref.read(terminateSessionProvider);
      try {
        await terminateSession(sessionName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Session terminated',
                style: GoogleFonts.dmSans(),
              ),
              backgroundColor: kDarkGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to terminate session',
                  style: GoogleFonts.dmSans()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Change Password',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Required';
                  if (value!.length < 8) return 'Min 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords don\'t match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: kTextGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                final changePassword = ref.read(changePasswordProvider);
                try {
                  await changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                  ref.invalidate(securitySettingsProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Password changed successfully',
                          style: GoogleFonts.dmSans(),
                        ),
                        backgroundColor: kDarkGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to change password',
                          style: GoogleFonts.dmSans(),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
            ),
            child: Text('Change', style: GoogleFonts.dmSans()),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFDC2626),
          ),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
          style: GoogleFonts.dmSans(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Account deletion not implemented',
                    style: GoogleFonts.dmSans(),
                  ),
                  backgroundColor: kTextGrey,
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.dmSans(
                color: const Color(0xFFDC2626),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
