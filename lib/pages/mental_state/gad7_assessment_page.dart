import 'package:flutter/material.dart';
import 'gad7_results_page.dart';

class Gad7AssessmentPage extends StatefulWidget {
  const Gad7AssessmentPage({super.key});

  @override
  State<Gad7AssessmentPage> createState() => _Gad7AssessmentPageState();
}

class _Gad7AssessmentPageState extends State<Gad7AssessmentPage> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _questions = [
    'Feeling nervous, anxious, or on edge',
    'Not being able to stop or control worrying',
    'Worrying too much about different things',
    'Trouble relaxing',
    'Being so restless that it is hard to sit still',
    'Becoming easily annoyed or irritable',
    'Feeling afraid as if something awful might happen',
  ];

  final List<Map<String, dynamic>> _chat = [];
  int _currentQuestionIndex = 0;
  bool _isSubmitting = false;
  bool _showSeeResultButton = false;

  void _submitAssessment() {
    final Map<int, int> answers = {
      for (int i = 0; i < _chat.length; i++)
        if (_chat[i]['isUser'] == true) i: _chat[i]['answerIndex'] as int,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Gad7ResultsPage(
          answers: answers,
        ),
      ),
    );
  }

  void _nextStep(int answerIndex) {
    setState(() {
      _chat.add({
        'isUser': true,
        'text': ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'][answerIndex],
        'answerIndex': answerIndex,
      });

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _chat.add({
          'isUser': false,
          'text': _questions[_currentQuestionIndex],
        });
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

  @override
  void initState() {
    super.initState();
    // Initialize chat with the first question
    _chat.add({
      'isUser': false,
      'text': _questions[_currentQuestionIndex],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAD-7 Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Introductory text
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Over the last two weeks, how often have you been bothered by the following problems?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold, // Changed from w500 to bold
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onBackground,
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
                  return Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message['isUser']
                            ? Theme.of(context).colorScheme.primary
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message['text'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: message['isUser']
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Answer buttons
            if (_currentQuestionIndex < _questions.length && !_isSubmitting)
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
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _nextStep(index),
                        child: Text(
                          ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'][index],
                        ),
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
                  child: const Text('See Result'),
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