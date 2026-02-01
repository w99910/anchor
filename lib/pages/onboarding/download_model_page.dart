import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../main.dart' show setOnboardingComplete;
import '../../utils/responsive.dart';
import '../main_scaffold.dart';

enum AiModelChoice { onDevice, cloud }

class DownloadModelPage extends StatefulWidget {
  const DownloadModelPage({super.key});

  @override
  State<DownloadModelPage> createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage> {
  AiModelChoice? _selectedChoice;
  bool _isSettingUp = false;
  double _setupProgress = 0.0;
  String? _errorMessage;

  void _selectChoice(AiModelChoice choice) {
    setState(() {
      _selectedChoice = choice;
      _errorMessage = null;
    });
  }

  Future<void> _continue() async {
    if (_selectedChoice == null) return;

    // if (_selectedChoice == AiModelChoice.onDevice) {
    //   // Navigate to dedicated download page
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const OnDeviceDownloadPage()),
    //   );
    //   return;
    // }

    // Cloud setup
    setState(() {
      _isSettingUp = true;
      _errorMessage = null;
    });

    try {
      // Cloud setup - simulate brief setup
      // for (var i = 0; i <= 10; i++) {
      //   await Future.delayed(const Duration(milliseconds: 50));
      //   if (mounted) {
      //     setState(() => _setupProgress = i / 10);
      //   }
      // }

      // Mark onboarding as complete
      await setOnboardingComplete();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScaffold(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSettingUp = false;
          _errorMessage = 'Setup failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              Text(
                l10n.chooseYourAi,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectHowToPowerAi,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // On-device option
              _ModelOptionCard(
                icon: Icons.smartphone_rounded,
                title: l10n.onDeviceAi,
                subtitle: l10n.maximumPrivacy,
                description: l10n.onDeviceDescription,
                benefits: [
                  l10n.completePrivacy,
                  l10n.worksOffline,
                  l10n.noSubscriptionNeeded,
                ],
                drawbacks: [l10n.requires2GBDownload, l10n.usesDeviceResources],
                isSelected: _selectedChoice == AiModelChoice.onDevice,
                onTap: _isSettingUp
                    ? null
                    : () => _selectChoice(AiModelChoice.onDevice),
              ),

              const SizedBox(height: 16),

              // Cloud option
              _ModelOptionCard(
                icon: Icons.cloud_rounded,
                title: l10n.cloudAi,
                subtitle: l10n.morePowerful,
                description: l10n.cloudDescription,
                benefits: [
                  l10n.moreCapableModels,
                  l10n.fasterResponses,
                  l10n.noStorageNeeded,
                ],
                drawbacks: [l10n.requiresInternet, l10n.dataSentToCloud],
                isSelected: _selectedChoice == AiModelChoice.cloud,
                onTap: _isSettingUp
                    ? null
                    : () => _selectChoice(AiModelChoice.cloud),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.setupFailed,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const Spacer(flex: 2),

              FilledButton(
                onPressed: _selectedChoice != null ? _continue : null,
                child: Text(l10n.continueText),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<String> benefits;
  final List<String> drawbacks;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ModelOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.benefits,
    required this.drawbacks,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : colorScheme.surface,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary.withOpacity(0.15)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ...benefits.map((b) => _Chip(text: b, isPositive: true)),
                  ...drawbacks.map((d) => _Chip(text: d, isPositive: false)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool isPositive;

  const _Chip({required this.text, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.check_rounded : Icons.info_outline_rounded,
            size: 12,
            color: isPositive ? Colors.green : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isPositive ? Colors.green : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
