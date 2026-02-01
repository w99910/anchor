import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'phq9_results_page.dart';

class Phq9AssessmentPage extends StatefulWidget {
  const Phq9AssessmentPage({super.key});

  @override
  State<Phq9AssessmentPage> createState() => _Phq9AssessmentPageState();
}

class _Phq9AssessmentPageState extends State<Phq9AssessmentPage> {
  final ScrollController _scrollController = ScrollController();

  List<String> _getQuestions(AppLocalizations l10n) => [
    l10n.phq9Question1,
    l10n.phq9Question2,
    l10n.phq9Question3,
    l10n.phq9Question4,
    l10n.phq9Question5,
    l10n.phq9Question6,
    l10n.phq9Question7,
    l10n.phq9Question8,
    l10n.phq9Question9,
  ];

  List<String> _getAnswerOptions(AppLocalizations l10n) => [
    l10n.answerNotAtAll,
    l10n.answerSeveralDays,
    l10n.answerMoreThanHalfDays,
    l10n.answerNearlyEveryDay,
  ];

  final List<Map<String, dynamic>> _chat = [];
  final Map<int, int> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isFinished = false;
  bool _initialized = false;

  void _initializeChat(AppLocalizations l10n) {
    if (_initialized) return;
    _initialized = true;
    final questions = _getQuestions(l10n);
    _chat.add({
      'isUser': false,
      'text': questions[_currentQuestionIndex],
    });
  }

  void _submitAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Phq9ResultsPage(answers: _answers),
      ),
    );
  }

  void _handleAnswer(int answerIndex, AppLocalizations l10n) {
    final questions = _getQuestions(l10n);
    final answerOptions = _getAnswerOptions(l10n);
    
    setState(() {
      // 1. Record the answer for the current question
      _answers[_currentQuestionIndex] = answerIndex;

      // 2. Add User's response to the chat
      _chat.add({
        'isUser': true,
        'text': answerOptions[answerIndex],
      });

      // 3. Check if there are more questions
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        // Add the next bot question to the chat
        _chat.add({
          'isUser': false,
          'text': questions[_currentQuestionIndex],
        });
      } else {
        _isFinished = true;
      }
    });

    // Auto-scroll logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final answerOptions = _getAnswerOptions(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Initialize chat with localized question
    _initializeChat(l10n);
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.phq9Assessment)),
      body: Column(
        children: [
          // Static Instruction Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.assessmentIntroText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          // Chat Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chat.length,
              itemBuilder: (context, index) {
                final message = _chat[index];
                final isUser = message['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? Theme.of(context).colorScheme.primary 
                          : isDark
                              ? Theme.of(context).colorScheme.surfaceContainerHighest
                              : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUser 
                            ? Theme.of(context).colorScheme.onPrimary 
                            : isDark
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Action Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isFinished
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitAssessment,
                      icon: const Icon(Icons.analytics_outlined),
                      label: Text(l10n.seeResult),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () => _handleAnswer(index, l10n),
                            child: Text(answerOptions[index]),
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
