import 'package:flutter/material.dart';
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

  final List<_Feature> _features = [
    _Feature(
      emoji: '📝',
      title: 'Journal your thoughts',
      description:
          'Express yourself freely and track your emotional journey over time.',
    ),
    _Feature(
      emoji: '💬',
      title: 'Talk to AI companion',
      description: 'Chat anytime with a supportive AI friend or therapist.',
    ),
    _Feature(
      emoji: '📊',
      title: 'Track your progress',
      description:
          'Understand your mental patterns with insights and evaluations.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _features.length - 1) {
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
                    'Skip',
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
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    return _FeaturePage(feature: _features[index]);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _PageIndicator(count: _features.length, current: _currentPage),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _currentPage < _features.length - 1
                        ? 'Next'
                        : 'Get Started',
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
