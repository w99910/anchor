import 'package:flutter/material.dart';
import 'evaluation_results_page.dart';

class EvaluationQuestionsPage extends StatefulWidget {
  final String evaluationType;

  const EvaluationQuestionsPage({super.key, required this.evaluationType});

  @override
  State<EvaluationQuestionsPage> createState() =>
      _EvaluationQuestionsPageState();
}

class _EvaluationQuestionsPageState extends State<EvaluationQuestionsPage> {
  int _currentQuestion = 0;
  final Map<int, int> _answers = {};

  late final List<_Question> _questions;

  @override
  void initState() {
    super.initState();
    _questions = widget.evaluationType == 'emotion'
        ? _emotionQuestions
        : _stressQuestions;
  }

  final List<_Question> _emotionQuestions = [
    _Question(
      text: 'How would you describe your overall mood today?',
      options: [
        'Very negative',
        'Somewhat negative',
        'Neutral',
        'Somewhat positive',
        'Very positive',
      ],
    ),
    _Question(
      text: 'How often have you felt anxious in the past week?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
    ),
    _Question(
      text: 'How well have you been sleeping?',
      options: ['Very poorly', 'Poorly', 'Okay', 'Well', 'Very well'],
    ),
    _Question(
      text: 'How connected do you feel to others?',
      options: [
        'Very disconnected',
        'Somewhat disconnected',
        'Neutral',
        'Somewhat connected',
        'Very connected',
      ],
    ),
    _Question(
      text: 'How hopeful do you feel about the future?',
      options: [
        'Not hopeful',
        'Slightly hopeful',
        'Somewhat hopeful',
        'Hopeful',
        'Very hopeful',
      ],
    ),
  ];

  final List<_Question> _stressQuestions = [
    _Question(
      text: 'How often have you felt overwhelmed recently?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
    ),
    _Question(
      text: 'How well can you manage your daily responsibilities?',
      options: [
        'Not at all',
        'With difficulty',
        'Somewhat',
        'Well',
        'Very well',
      ],
    ),
    _Question(
      text: 'How often do you feel tense or on edge?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
    ),
    _Question(
      text: 'How would you rate your work-life balance?',
      options: ['Very poor', 'Poor', 'Average', 'Good', 'Excellent'],
    ),
    _Question(
      text: 'How often do you take time for self-care?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Daily'],
    ),
  ];

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestion] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
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
    final question = _questions[_currentQuestion];
    final hasAnswer = _answers.containsKey(_currentQuestion);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.evaluationType == 'emotion'
              ? 'Emotion Assessment'
              : 'Stress Assessment',
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentQuestion + 1) / _questions.length,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestion + 1} of ${_questions.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),

                  // Options
                  ...question.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _answers[_currentQuestion] == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentQuestion > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentQuestion > 0) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: hasAnswer ? _nextQuestion : null,
                    child: Text(
                      _currentQuestion < _questions.length - 1
                          ? 'Next'
                          : 'See Results',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Question {
  final String text;
  final List<String> options;

  _Question({required this.text, required this.options});
}
