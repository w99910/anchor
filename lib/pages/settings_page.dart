import 'package:flutter/material.dart';
import '../main.dart' show themeNotifier, saveTheme;
import '../services/ai_settings_service.dart';
import '../services/gemini_service.dart';
import '../utils/responsive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _appLock = false;
  final _aiSettings = AiSettingsService();
  final _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _aiSettings.addListener(_onSettingsChanged);
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    await _aiSettings.initialize();
    if (mounted) setState(() {});
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _aiSettings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: ResponsiveCenter(
            maxWidth: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                _SectionTitle('Appearance'),
                _ThemeSelector(),

                const SizedBox(height: 24),
                _SectionTitle('AI Provider'),
                _AiProviderSelector(
                  isCloudProvider: _aiSettings.isCloudProvider,
                  isGeminiConfigured: _geminiService.isConfigured,
                  onChanged: (useCloud) => _onAiProviderChanged(useCloud),
                ),

                const SizedBox(height: 24),
                _SectionTitle('Security'),
                _ToggleTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'App lock',
                  value: _appLock,
                  onChanged: (v) => setState(() => _appLock = v),
                ),

                const SizedBox(height: 24),
                _SectionTitle('Notifications'),
                _ToggleTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push notifications',
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),

                const SizedBox(height: 24),
                _SectionTitle('Data'),
                _ActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Clear history',
                  onTap: () => _showClearDialog(context),
                ),
                _ActionTile(
                  icon: Icons.download_outlined,
                  title: 'Export data',
                  onTap: () {},
                ),

                const SizedBox(height: 24),
                _SectionTitle('About'),
                _ActionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Anchor',
                  onTap: () => _showAbout(context),
                ),
                _ActionTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy policy',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  onTap: () {},
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAiProviderChanged(bool useCloud) async {
    if (useCloud) {
      // Show privacy warning dialog before switching to cloud
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.cloud_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Use Cloud AI?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You are about to switch to a cloud AI provider (Gemini).',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your conversations will be sent to Google servers. We cannot guarantee data privacy when using cloud AI.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'For maximum privacy, use the on-device AI option.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('I Understand'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _aiSettings.setAiProvider(AiProvider.cloud);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Switched to Cloud AI (Gemini)'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      // Switch to on-device without warning
      await _aiSettings.setAiProvider(AiProvider.onDevice);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Switched to On-Device AI'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text(
          'This will delete all your data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('History cleared')));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Anchor',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.anchor_rounded,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      children: const [Text('Your mental wellness companion.')],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _ThemeOption(
                icon: Icons.brightness_auto_rounded,
                title: 'System',
                isSelected: themeMode == ThemeMode.system,
                onTap: () => saveTheme(ThemeMode.system),
                showDivider: true,
              ),
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                title: 'Light',
                isSelected: themeMode == ThemeMode.light,
                onTap: () => saveTheme(ThemeMode.light),
                showDivider: true,
              ),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                title: 'Dark',
                isSelected: themeMode == ThemeMode.dark,
                onTap: () => saveTheme(ThemeMode.dark),
                showDivider: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : null,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(title),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(title),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _AiProviderSelector extends StatelessWidget {
  final bool isCloudProvider;
  final bool isGeminiConfigured;
  final ValueChanged<bool> onChanged;

  const _AiProviderSelector({
    required this.isCloudProvider,
    required this.isGeminiConfigured,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _AiProviderOption(
            icon: Icons.memory_rounded,
            title: 'On-Device',
            subtitle: 'Private, runs locally',
            isSelected: !isCloudProvider,
            onTap: () => onChanged(false),
            showDivider: true,
          ),
          _AiProviderOption(
            icon: Icons.cloud_rounded,
            title: 'Cloud (Gemini)',
            subtitle: isGeminiConfigured
                ? 'Faster, requires internet'
                : 'API key not configured',
            isSelected: isCloudProvider,
            onTap: isGeminiConfigured ? () => onChanged(true) : null,
            showDivider: false,
            isDisabled: !isGeminiConfigured,
          ),
        ],
      ),
    );
  }
}

class _AiProviderOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool isDisabled;

  const _AiProviderOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: isDisabled ? null : onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: Icon(
            icon,
            color: isDisabled
                ? Theme.of(context).colorScheme.outline
                : isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : null,
              color: isDisabled
                  ? Theme.of(context).colorScheme.outline
                  : isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDisabled
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 56,
            endIndent: 16,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
      ],
    );
  }
}
