import 'package:flutter/material.dart';
import 'evaluation_questions_page.dart';

class MentalStatePage extends StatelessWidget {
  const MentalStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental State Evaluation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose an Evaluation',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Select the type of assessment you\'d like to take',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Emotion Test
            _EvaluationCard(
              title: 'Emotion Assessment',
              description:
                  'Understand your current emotional state and identify patterns',
              icon: Icons.favorite,
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EvaluationQuestionsPage(
                      evaluationType: 'emotion',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Stress Test
            _EvaluationCard(
              title: 'Stress Assessment',
              description:
                  'Measure your stress levels and get personalized insights',
              icon: Icons.bolt,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const EvaluationQuestionsPage(evaluationType: 'stress'),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Past Results Section
            Text(
              'Past Evaluations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _PastResultCard(
              type: 'Emotion',
              date: 'Jan 25, 2026',
              score: 72,
              status: 'Good',
              color: Colors.green,
            ),
            _PastResultCard(
              type: 'Stress',
              date: 'Jan 20, 2026',
              score: 45,
              status: 'Moderate',
              color: Colors.amber,
            ),
            _PastResultCard(
              type: 'Emotion',
              date: 'Jan 15, 2026',
              score: 85,
              status: 'Excellent',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _EvaluationCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PastResultCard extends StatelessWidget {
  final String type;
  final String date;
  final int score;
  final String status;
  final Color color;

  const _PastResultCard({
    required this.type,
    required this.date,
    required this.score,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            '$score',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('$type Assessment'),
        subtitle: Text(date),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
