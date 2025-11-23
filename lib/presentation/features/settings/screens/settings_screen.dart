import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            // General Section
            _buildSectionHeader('General'),
            _buildListTile(
              context,
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: _getThemeLabel(settings.theme),
              onTap: () => _showThemeDialog(context, ref, settings.theme),
            ),
            _buildListTile(
              context,
              icon: Icons.language,
              title: 'Language',
              subtitle: _getLanguageLabel(settings.language),
              onTap: () => _showLanguageDialog(context, ref, settings.language),
            ),
            _buildListTile(
              context,
              icon: Icons.attach_money,
              title: 'Currency',
              subtitle: settings.currency,
            ),

            const Divider(height: 32),

            // Notifications Section
            _buildSectionHeader('Notifications'),
            _buildSwitchTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Enable push notifications',
              value: settings.notifications.enabled,
              onChanged: null, // Will implement in future
            ),
            _buildSwitchTile(
              context,
              icon: Icons.volume_up_outlined,
              title: 'Sound',
              subtitle: 'Play sound for notifications',
              value: settings.notifications.sound,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateNotificationSound(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.vibration,
              title: 'Vibration',
              subtitle: 'Vibrate for notifications',
              value: settings.notifications.vibration,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateNotificationVibration(value),
            ),

            const Divider(height: 32),

            // Privacy Section
            _buildSectionHeader('Privacy'),
            _buildSwitchTile(
              context,
              icon: Icons.visibility_outlined,
              title: 'Show Online Status',
              subtitle: 'Let others see when you\'re online',
              value: settings.privacy.showOnlineStatus,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateShowOnlineStatus(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.access_time,
              title: 'Show Last Seen',
              subtitle: 'Let others see your last active time',
              value: settings.privacy.showLastSeen,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateShowLastSeen(value),
            ),

            const Divider(height: 32),

            // Display Section
            _buildSectionHeader('Display'),
            _buildListTile(
              context,
              icon: Icons.text_fields,
              title: 'Text Size',
              subtitle: _getTextSizeLabel(settings.display.textSize),
              onTap: () =>
                  _showTextSizeDialog(context, ref, settings.display.textSize),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.data_saver_on,
              title: 'Data Saver',
              subtitle: 'Reduce data usage',
              value: settings.display.dataSaver,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateDataSaver(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.play_circle_outline,
              title: 'Auto-play Videos',
              subtitle: 'Automatically play videos in feed',
              value: settings.display.autoPlayVideos,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateAutoPlayVideos(value),
            ),

            const Divider(height: 32),

            // Security Section
            _buildSectionHeader('Security'),
            _buildSwitchTile(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID',
              value: settings.biometricEnabled,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateBiometric(value),
            ),

            const Divider(height: 32),

            // Other Section
            _buildSectionHeader('Other'),
            _buildSwitchTile(
              context,
              icon: Icons.location_on_outlined,
              title: 'Location Services',
              subtitle: 'Enable location-based features',
              value: settings.locationServicesEnabled,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateLocationServices(value),
            ),
            _buildSwitchTile(
              context,
              icon: Icons.history,
              title: 'Search History',
              subtitle: 'Save your search history',
              value: settings.searchHistoryEnabled,
              onChanged: (value) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateSearchHistory(value),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Last synced: ${_formatSyncTime(settings.syncedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(settingsNotifierProvider.notifier)
                      .loadSettings(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }

  String _getThemeLabel(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'auto':
        return 'Auto';
      default:
        return theme;
    }
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return language;
    }
  }

  String _getTextSizeLabel(String size) {
    switch (size) {
      case 'small':
        return 'Small';
      case 'medium':
        return 'Medium';
      case 'large':
        return 'Large';
      default:
        return size;
    }
  }

  String _formatSyncTime(DateTime syncedAt) {
    final now = DateTime.now();
    final difference = now.difference(syncedAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, String currentTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Auto'),
              value: 'auto',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, WidgetRef ref, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'id',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSizeDialog(
      BuildContext context, WidgetRef ref, String currentSize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Small'),
              value: 'small',
              groupValue: currentSize,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTextSize(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Medium'),
              value: 'medium',
              groupValue: currentSize,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTextSize(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Large'),
              value: 'large',
              groupValue: currentSize,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsNotifierProvider.notifier)
                      .updateTextSize(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
