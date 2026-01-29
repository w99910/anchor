import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import 'download_model_page.dart';

class PersonalizedQuestionsPage extends StatefulWidget {
  const PersonalizedQuestionsPage({super.key});

  @override
  State<PersonalizedQuestionsPage> createState() =>
      _PersonalizedQuestionsPageState();
}

class _PersonalizedQuestionsPageState extends State<PersonalizedQuestionsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<int, String> _answers = {};

  final List<_Question> _questions = [
    _Question(
      question: 'What brings you here?',
      options: [
        'Manage stress',
        'Track mood',
        'Build habits',
        'Self-reflection',
        'Just exploring',
      ],
    ),
    _Question(
      question: 'How often would you like to journal?',
      options: ['Daily', 'Few times a week', 'Weekly', 'When I feel like it'],
    ),
    _Question(
      question: 'What time works best for check-ins?',
      options: ['Morning', 'Afternoon', 'Evening', 'Flexible'],
    ),
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentPage] = answer;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentPage < _questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DownloadModelPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Spacer(),
                  TextButton(onPressed: _continue, child: const Text('Skip')),
                ],
              ),
              const SizedBox(height: 8),

              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _questions.length,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_currentPage + 1} of ${_questions.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _QuestionPage(
                      question: _questions[index],
                      selectedAnswer: _answers[index],
                      onSelect: _selectAnswer,
                    );
                  },
                ),
              ),

              if (_currentPage == _questions.length - 1 &&
                  _answers.containsKey(_currentPage))
                FilledButton(
                  onPressed: _continue,
                  child: const Text('Continue'),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;

  _Question({required this.question, required this.options});
}

class _QuestionPage extends StatelessWidget {
  final _Question question;
  final String? selectedAnswer;
  final ValueChanged<String> onSelect;

  const _QuestionPage({
    required this.question,
    required this.selectedAnswer,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          question.question,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 32),
        ...question.options.map((option) {
          final isSelected = selectedAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionTile(
              text: option,
              isSelected: isSelected,
              onTap: () => onSelect(option),
            ),
          );
        }),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
