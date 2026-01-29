import 'package:flutter/material.dart';

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
    if (_score >= 80) return 'Excellent';
    if (_score >= 60) return 'Good';
    if (_score >= 40) return 'Moderate';
    return 'Needs Attention';
  }

  Color get _statusColor {
    if (_score >= 80) return Colors.green;
    if (_score >= 60) return Colors.lightGreen;
    if (_score >= 40) return Colors.amber;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Score Circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor.withOpacity(0.2),
                border: Border.all(color: _statusColor, width: 8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_score',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                    Text(
                      _status,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: _statusColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              evaluationType == 'emotion'
                  ? 'Emotional Well-being Score'
                  : 'Stress Management Score',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              _getDescription(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Recommendations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recommendations',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._getRecommendations().map(
                      (rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(rec)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to help/therapist page
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Talk to a Professional'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDescription() {
    if (_score >= 80) {
      return 'Great job! Your ${evaluationType == 'emotion' ? 'emotional health' : 'stress levels'} appear to be well-managed. Keep up the good practices!';
    }
    if (_score >= 60) {
      return 'You\'re doing well overall. There\'s room for improvement in some areas, but you\'re on the right track.';
    }
    if (_score >= 40) {
      return 'Your results suggest some ${evaluationType == 'emotion' ? 'emotional challenges' : 'stress factors'} that could benefit from attention and support.';
    }
    return 'Your results indicate significant ${evaluationType == 'emotion' ? 'emotional distress' : 'stress levels'}. Consider reaching out to a professional for support.';
  }

  List<String> _getRecommendations() {
    if (evaluationType == 'emotion') {
      return [
        'Practice daily gratitude journaling',
        'Maintain regular sleep schedule',
        'Connect with friends and family',
        'Consider mindfulness meditation',
      ];
    }
    return [
      'Take regular breaks during work',
      'Practice deep breathing exercises',
      'Set boundaries with work and personal time',
      'Engage in physical activity',
    ];
  }
}
