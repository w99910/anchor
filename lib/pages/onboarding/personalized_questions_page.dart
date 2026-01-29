import 'package:flutter/material.dart';
import 'download_model_page.dart';

class PersonalizedQuestionsPage extends StatefulWidget {
  const PersonalizedQuestionsPage({super.key});

  @override
  State<PersonalizedQuestionsPage> createState() =>
      _PersonalizedQuestionsPageState();
}

class _PersonalizedQuestionsPageState extends State<PersonalizedQuestionsPage> {
  final Map<String, String?> _answers = {};

  final List<_Question> _questions = [
    _Question(
      id: 'goal',
      question: 'What brings you to Anchor?',
      options: [
        'Manage stress',
        'Track my mood',
        'Build healthy habits',
        'Talk to someone',
        'Just exploring',
      ],
    ),
    _Question(
      id: 'frequency',
      question: 'How often do you want to journal?',
      options: ['Daily', 'A few times a week', 'Weekly', 'When I feel like it'],
    ),
    _Question(
      id: 'experience',
      question: 'Have you used mental health apps before?',
      options: [
        'Yes, regularly',
        'Yes, occasionally',
        'No, this is my first time',
      ],
    ),
  ];

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DownloadModelPage()),
    );
  }

  void _skip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DownloadModelPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalize'),
        actions: [TextButton(onPressed: _skip, child: const Text('Skip'))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Optional Questions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Help us understand you better (optional)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            ..._questions.map(
              (question) => _QuestionCard(
                question: question,
                selectedAnswer: _answers[question.id],
                onAnswerSelected: (answer) {
                  setState(() {
                    _answers[question.id] = answer;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _continue, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String id;
  final String question;
  final List<String> options;

  _Question({required this.id, required this.question, required this.options});
}

class _QuestionCard extends StatelessWidget {
  final _Question question;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;

  const _QuestionCard({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.options.map((option) {
                final isSelected = selectedAnswer == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => onAnswerSelected(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
