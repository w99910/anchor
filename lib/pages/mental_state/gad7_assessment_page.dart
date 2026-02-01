import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'gad7_results_page.dart';

class Gad7AssessmentPage extends StatefulWidget {
  const Gad7AssessmentPage({super.key});

  @override
  State<Gad7AssessmentPage> createState() => _Gad7AssessmentPageState();
}

class _Gad7AssessmentPageState extends State<Gad7AssessmentPage> {
  final ScrollController _scrollController = ScrollController();

  List<String> _getQuestions(AppLocalizations l10n) => [
    l10n.gad7Question1,
    l10n.gad7Question2,
    l10n.gad7Question3,
    l10n.gad7Question4,
    l10n.gad7Question5,
    l10n.gad7Question6,
    l10n.gad7Question7,
  ];

  List<String> _getAnswerOptions(AppLocalizations l10n) => [
    l10n.answerNotAtAll,
    l10n.answerSeveralDays,
    l10n.answerMoreThanHalfDays,
    l10n.answerNearlyEveryDay,
  ];

  final List<Map<String, dynamic>> _chat = [];
  int _currentQuestionIndex = 0;
  bool _isSubmitting = false;
  bool _showSeeResultButton = false;
  bool _initialized = false;

  void _submitAssessment() {
    final Map<int, int> answers = {
      for (int i = 0; i < _chat.length; i++)
        if (_chat[i]['isUser'] == true) i: _chat[i]['answerIndex'] as int,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Gad7ResultsPage(answers: answers),
      ),
    );
  }

  void _nextStep(int answerIndex, AppLocalizations l10n) {
    final questions = _getQuestions(l10n);
    final answers = _getAnswerOptions(l10n);

    setState(() {
      _chat.add({
        'isUser': true,
        'text': answers[answerIndex],
        'answerIndex': answerIndex,
      });

      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _chat.add({'isUser': false, 'text': questions[_currentQuestionIndex]});
      } else {
        _submitAssessment();
      }
    });

    // Auto-scroll to the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _initializeChat(AppLocalizations l10n) {
    if (_initialized) return;
    _initialized = true;
    final questions = _getQuestions(l10n);
    _chat.add({'isUser': false, 'text': questions[_currentQuestionIndex]});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final questions = _getQuestions(l10n);
    final answerOptions = _getAnswerOptions(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Initialize chat with localized question
    _initializeChat(l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gad7Assessment)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Introductory text
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chat.length,
                itemBuilder: (context, index) {
                  final message = _chat[index];
                  final isUser = message['isUser'] as bool;
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : isDark
                            ? Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest
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
                              : Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Answer buttons
            if (_currentQuestionIndex < questions.length && !_isSubmitting)
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _nextStep(index, l10n),
                        child: Text(answerOptions[index]),
                      ),
                    ),
                  ),
                ),
              ),

            // See Result button
            if (_showSeeResultButton)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submitAssessment,
                  child: Text(l10n.seeResult),
                ),
              ),

            // Loading indicator
            if (_isSubmitting)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
