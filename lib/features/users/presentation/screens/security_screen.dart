import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/users/presentation/providers/profile_controller.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
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
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final securitySettingsAsync = ref.watch(securitySettingsProvider);
    final userProfileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Security',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: userProfileAsync.when(
        initial: () => const SizedBox(),
        loading: () => const Center(
          child: CircularProgressIndicator(color: kDarkGreen),
        ),
        error: (error) => Center(
          child: Text(error.toString(), style: TextStyle()),
        ),
        data: (profile) {
          return securitySettingsAsync.when(
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
                        icon: PhosphorIconsRegular.shieldCheck,
                        value: settings.twoFactorEnabled,
                        onChanged: (value) => _toggleTwoFactor(value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint or face recognition',
                        icon: PhosphorIconsRegular.fingerprint,
                        value: settings.biometricEnabled,
                        onChanged: (value) => _toggleBiometric(value),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        title: 'Email Notifications',
                        subtitle: 'Get notified of security events',
                        icon: PhosphorIconsRegular.envelope,
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
                        icon: PhosphorIconsRegular.lock,
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
                          Icon(PhosphorIconsRegular.warning,
                              color: const Color(0xFFDC2626), size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Delete Account',
                            style: TextStyle(
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
                        style: TextStyle(
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
                            style: TextStyle(fontWeight: FontWeight.w600),
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
                style: TextStyle(color: kTextGrey),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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
            child: PhosphorIcon(icon, color: kDarkGreen, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
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
                child: PhosphorIcon(icon, color: kDarkGreen, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIconsRegular.caretRight, color: kPillGrey, size: 20),
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
            child: PhosphorIcon(
              isCurrent ? PhosphorIconsRegular.deviceMobile : PhosphorIconsRegular.devices,
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'This device',
                    style: TextStyle(
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
                style: TextStyle(
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

  Future<void> _toggleTwoFactor(bool value) async {
    try {
      final profileController = ref.read(profileControllerProvider.notifier);
      await profileController.updateTwoFactor(value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update two-factor authentication',
              style: TextStyle(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    try {
      final profileController = ref.read(profileControllerProvider.notifier);
      await profileController.updateBiometric(value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update biometric login',
              style: TextStyle(),
            ),
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
              style: TextStyle(),
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
                Text('Failed to update setting', style: TextStyle()),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to terminate this session?',
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Terminate',
              style: TextStyle(
                color: const Color(0xFFDC2626),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final profileController = ref.read(profileControllerProvider.notifier);
        await profileController.terminateSession(sessionName);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Session terminated',
                style: TextStyle(),
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
                  style: TextStyle()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
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
                controller: _newPasswordController,
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
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
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
            child: Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                final profileController = ref.read(profileControllerProvider.notifier);
                try {
                  await profileController.changePassword(
                    currentPassword: _currentPasswordController.text,
                    newPassword: _newPasswordController.text,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Password changed successfully',
                          style: TextStyle(),
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
                          style: TextStyle(),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Change Password',
                style: TextStyle(fontWeight: FontWeight.w600)),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFDC2626),
          ),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Account deletion not implemented',
                    style: TextStyle(),
                  ),
                  backgroundColor: kTextGrey,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(
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
