import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import 'user_info_page.dart';

class FeatureIntroPage extends StatefulWidget {
  const FeatureIntroPage({super.key});

  @override
  State<FeatureIntroPage> createState() => _FeatureIntroPageState();
}

class _FeatureIntroPageState extends State<FeatureIntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_Feature> _getFeatures(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _Feature(
        emoji: '📝',
        title: l10n.journalYourThoughts,
        description: l10n.journalDescription,
      ),
      _Feature(
        emoji: '💬',
        title: l10n.talkToAiCompanion,
        description: l10n.talkToAiDescription,
      ),
      _Feature(
        emoji: '📊',
        title: l10n.trackYourProgress,
        description: l10n.trackProgressDescription,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final features = _getFeatures(context);
    if (_currentPage < features.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserInfoPage()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = _getFeatures(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    l10n.skip,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return _FeaturePage(feature: features[index]);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _PageIndicator(count: features.length, current: _currentPage),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _currentPage < features.length - 1
                        ? l10n.next
                        : l10n.getStarted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final String emoji;
  final String title;
  final String description;

  _Feature({
    required this.emoji,
    required this.title,
    required this.description,
  });
}

class _FeaturePage extends StatelessWidget {
  final _Feature feature;

  const _FeaturePage({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(feature.emoji, style: const TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 48),
          Text(
            feature.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
