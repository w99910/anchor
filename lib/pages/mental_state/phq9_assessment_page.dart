import 'package:flutter/material.dart';
import 'phq9_results_page.dart';

class Phq9AssessmentPage extends StatefulWidget {
  const Phq9AssessmentPage({super.key});

  @override
  State<Phq9AssessmentPage> createState() => _Phq9AssessmentPageState();
}

class _Phq9AssessmentPageState extends State<Phq9AssessmentPage> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _questions = [
    'Little interest or pleasure in doing things',
    'Feeling down, depressed, or hopeless',
    'Trouble falling or staying asleep, or sleeping too much',
    'Feeling tired or having little energy',
    'Poor appetite or overeating',
    'Feeling bad about yourself — or that you are a failure or have let yourself or your family down',
    'Trouble concentrating on things, such as reading the newspaper or watching television',
    'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual',
    'Thoughts that you would be better off dead or of hurting yourself in some way',
  ];

  final List<Map<String, dynamic>> _chat = [];
  final Map<int, int> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    // Initialize the chat with the very first question
    _chat.add({
      'isUser': false,
      'text': _questions[_currentQuestionIndex],
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

  void _handleAnswer(int answerIndex) {
    setState(() {
      // 1. Record the answer for the current question
      _answers[_currentQuestionIndex] = answerIndex;

      // 2. Add User's response to the chat
      _chat.add({
        'isUser': true,
        'text': ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'][answerIndex],
      });

      // 3. Check if there are more questions
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        // Add the next bot question to the chat
        _chat.add({
          'isUser': false,
          'text': _questions[_currentQuestionIndex],
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
    return Scaffold(
      appBar: AppBar(title: const Text('PHQ-9 Assessment')),
      body: Column(
        children: [
          // Static Instruction Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Over the last two weeks, how often have you been bothered by the following problems?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.5,
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
                final isUser = message['isUser'];
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
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
                      label: const Text('See Result'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight, // Aligns the whole column to the right
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Aligns buttons within the column
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () => _handleAnswer(index),
                            child: Text([
                              'Not at all',
                              'Several days',
                              'More than half the days',
                              'Nearly every day'
                            ][index]),
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