import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class Phq9ResultsPage extends StatelessWidget {
  final Map<int, int> answers;

  const Phq9ResultsPage({
    super.key,
    required this.answers,
  });

  int get _score {
    if (answers.isEmpty) return 0;
    final total = answers.values.reduce((a, b) => a + b);
    return total;
  }

  // PHQ-9 Specific Thresholds
  String get _status {
    if (_score <= 4) return 'Minimal depression';
    if (_score <= 9) return 'Mild depression';
    if (_score <= 14) return 'Moderate depression';
    if (_score <= 19) return 'Moderately severe';
    return 'Severe depression';
  }

  Color get _statusColor {
    if (_score <= 4) return Colors.green;
    if (_score <= 9) return Colors.lightGreen;
    if (_score <= 14) return Colors.amber;
    if (_score <= 19) return Colors.orange;
    return Colors.red;
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
                      textAlign: TextAlign.center,
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
                'PHQ-9 Depression Assessment',
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
                          'Next Steps',
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
    if (_score <= 4) {
      return 'Symptoms suggest minimal depression. Continue monitoring your mood.';
    }
    if (_score <= 9) {
      return 'Symptoms suggest mild depression. It may be helpful to talk with a counselor.';
    }
    if (_score <= 14) {
      return 'Symptoms suggest moderate depression. Consider a consultation with a healthcare professional.';
    }
    if (_score <= 19) {
      return 'Symptoms suggest moderately severe depression. Please reach out to a professional for support.';
    }
    return 'Symptoms suggest severe depression. We strongly recommend seeking immediate professional help.';
  }

  List<String> _getRecommendations() {
    List<String> recs = [
      'Maintain a routine for sleep and meals',
      'Set small, achievable daily goals',
      'Stay connected with your support network',
    ];

    // If score is high or Q9 (Suicidal ideation) is marked, add urgent advice
    if (_score >= 15 || (answers[8] ?? 0) > 0) {
      recs.insert(0, 'Contact a mental health crisis hotline');
    }
    
    return recs;
  }
}