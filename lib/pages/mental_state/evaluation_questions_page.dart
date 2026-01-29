import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import 'evaluation_results_page.dart';

class EvaluationQuestionsPage extends StatefulWidget {
  final String evaluationType;

  const EvaluationQuestionsPage({super.key, required this.evaluationType});

  @override
  State<EvaluationQuestionsPage> createState() =>
      _EvaluationQuestionsPageState();
}

class _EvaluationQuestionsPageState extends State<EvaluationQuestionsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<int, int> _answers = {};

  late final List<_Question> _questions;

  @override
  void initState() {
    super.initState();
    _questions = widget.evaluationType == 'emotion'
        ? _emotionQuestions
        : _stressQuestions;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<_Question> _emotionQuestions = [
    _Question('How would you describe your mood today?', [
      'Very low',
      'Low',
      'Neutral',
      'Good',
      'Great',
    ]),
    _Question('How often have you felt anxious this week?', [
      'Always',
      'Often',
      'Sometimes',
      'Rarely',
      'Never',
    ]),
    _Question('How well have you been sleeping?', [
      'Very poorly',
      'Poorly',
      'Okay',
      'Well',
      'Very well',
    ]),
    _Question('How connected do you feel to others?', [
      'Very disconnected',
      'Disconnected',
      'Neutral',
      'Connected',
      'Very connected',
    ]),
  ];

  final List<_Question> _stressQuestions = [
    _Question('How overwhelmed have you felt recently?', [
      'Extremely',
      'Very',
      'Moderately',
      'Slightly',
      'Not at all',
    ]),
    _Question('How well can you manage daily tasks?', [
      'Not at all',
      'With difficulty',
      'Somewhat',
      'Well',
      'Very well',
    ]),
    _Question('How often do you feel tense?', [
      'Always',
      'Often',
      'Sometimes',
      'Rarely',
      'Never',
    ]),
    _Question('How would you rate your work-life balance?', [
      'Very poor',
      'Poor',
      'Average',
      'Good',
      'Excellent',
    ]),
  ];

  void _selectAnswer(int index) {
    setState(() => _answers[_currentPage] = index);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (_currentPage < _questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluationResultsPage(
          evaluationType: widget.evaluationType,
          answers: _answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswer = _answers.containsKey(_currentPage);
    final isLast = _currentPage == _questions.length - 1;

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
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                    final question = _questions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          question.text,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 32),
                        ...question.options.asMap().entries.map((entry) {
                          final optionIndex = entry.key;
                          final option = entry.value;
                          final isSelected = _answers[index] == optionIndex;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OptionTile(
                              text: option,
                              isSelected: isSelected,
                              onTap: () => _selectAnswer(optionIndex),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),

              if (isLast && hasAnswer)
                FilledButton(
                  onPressed: _showResults,
                  child: const Text('See Results'),
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
  final String text;
  final List<String> options;

  _Question(this.text, this.options);
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
    return Material(
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
    );
  }
}
