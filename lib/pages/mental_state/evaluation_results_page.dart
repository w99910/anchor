import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class EvaluationResultsPage extends StatelessWidget {
  final String evaluationType;
  final Map<int, int> answers;

  const EvaluationResultsPage({
    super.key,
    required this.evaluationType,
    required this.answers,
  });

  int get _score {
    if (answers.isEmpty) return 0;
    final total = answers.values.reduce((a, b) => a + b);
    return ((total / (answers.length * 4)) * 100).round();
  }

  String get _status {
    if (_score >= 75) return 'Excellent';
    if (_score >= 50) return 'Good';
    if (_score >= 25) return 'Moderate';
    return 'Needs attention';
  }

  Color get _statusColor {
    if (_score >= 75) return Colors.green;
    if (_score >= 50) return Colors.lightGreen;
    if (_score >= 25) return Colors.amber;
    return Colors.orange;
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
              const Spacer(),

              // Score display
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor.withOpacity(0.1),
                  border: Border.all(color: _statusColor, width: 6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_score',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                evaluationType == 'emotion'
                    ? 'Emotional well-being'
                    : 'Stress management',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                _getDescription(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Recommendations
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Suggestions',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._getRecommendations().map(
                      (rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rec,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              FilledButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Done'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text('Talk to a professional'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getDescription() {
    if (_score >= 75) {
      return 'Great job! Your ${evaluationType == 'emotion' ? 'emotional health' : 'stress levels'} appear well-managed.';
    }
    if (_score >= 50) {
      return 'You\'re doing well. There\'s room for improvement in some areas.';
    }
    if (_score >= 25) {
      return 'Consider giving some attention to your ${evaluationType == 'emotion' ? 'emotional well-being' : 'stress management'}.';
    }
    return 'Reaching out to a professional could be beneficial for support.';
  }

  List<String> _getRecommendations() {
    if (evaluationType == 'emotion') {
      return [
        'Practice gratitude journaling daily',
        'Maintain a regular sleep schedule',
        'Connect with friends and family',
      ];
    }
    return [
      'Take regular breaks during work',
      'Practice deep breathing exercises',
      'Set boundaries with work and personal time',
    ];
  }
}
