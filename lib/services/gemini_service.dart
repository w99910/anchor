import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Service for Google Gemini AI API
class GeminiService extends ChangeNotifier {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _model = 'gemini-2.5-flash-preview-09-2025';

  /// Get API key from environment
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Check if API key is configured
  bool get isConfigured => _apiKey.isNotEmpty;

  /// Generate a response using Gemini API
  Future<String> generateResponse({
    required String prompt,
    required String mode, // 'friend' or 'therapist'
    int maxTokens = 1024,
    double temperature = 0.7,
    StreamController<String>? streamController,
  }) async {
    if (!isConfigured) {
      throw Exception('Gemini API key not configured');
    }

    final systemPrompt = _getSystemPrompt(mode);

    try {
      final url = Uri.parse(
        '$_baseUrl/models/$_model:generateContent?key=$_apiKey',
      );

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'systemInstruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
        'generationConfig': {
          'temperature': temperature,
          'maxOutputTokens': maxTokens,
          'topP': 0.95,
          'topK': 40,
        },
        'safetySettings': [
          {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_NONE'},
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_NONE',
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_NONE',
          },
        ],
      };

      debugPrint('Sending request to Gemini API...');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        debugPrint('Gemini API error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Gemini API error: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Gemini API response: ${response.body}');

      // Extract text from response
      final candidates = jsonResponse['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        debugPrint(
          'No candidates in response. Full response: ${response.body}',
        );
        throw Exception('No response from Gemini');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        debugPrint('Empty parts in response. Candidate: ${candidates[0]}');
        throw Exception('Empty response from Gemini');
      }

      final text = parts[0]['text'] as String? ?? '';

      // Stream the response if streaming is enabled
      if (streamController != null) {
        // Simulate streaming by sending chunks
        for (int i = 0; i < text.length; i += 5) {
          final chunk = text.substring(
            0,
            i + 5 > text.length ? text.length : i + 5,
          );
          streamController.add(chunk);
          await Future.delayed(const Duration(milliseconds: 20));
        }
      }

      debugPrint(
        'Gemini response received: ${text.substring(0, text.length > 50 ? 50 : text.length)}...',
      );
      return text;
    } catch (e) {
      debugPrint('Error calling Gemini API: $e');
      rethrow;
    }
  }

  /// Get system prompt based on mode
  String _getSystemPrompt(String mode) {
    if (mode == 'friend') {
      return '''You are a warm, genuine, and supportive friend. You are NOT a clinical therapist.

Guidelines:

Active Reassurance: Do not just reflect the user's feelings back to them. You must actively validate them. If they share a negative thought (like 'I'm a failure'), explicitly tell them that one mistake does not define them.

Normalize: Remind the user that their struggles (like burnout or missing deadlines) are a normal part of being human.

Conversational Tone: Speak naturally. Use phrases like 'I get it,' 'That is so heavy,' or 'I'm here for you.'

Less Asking, More Sharing: Do not end every message with a question. Sometimes, just sitting with the emotion is enough. If you do ask a question, make it casual.''';
    } else {
      return '''Role: You are a compassionate, professional, and non-judgmental AI therapist. You draw upon techniques from Cognitive Behavioral Therapy (CBT) and Person-Centered Therapy.

Core Objective: Your goal is not to "fix" the user or give direct advice, but to help them explore their emotions, identify cognitive distortions (negative thought patterns), and find their own clarity.

Guidelines:

Reflective Listening: Start by validating the user's feelings to establish safety (e.g., "It sounds like you're carrying a heavy burden...").

Socratic Questioning: Use open-ended, probing questions to help the user examine the evidence for their beliefs. (e.g., "What evidence do you have that supports this fear? Is there evidence that contradicts it?")

Identify Distortions: If the user exhibits common cognitive distortions (like catastrophizing, all-or-nothing thinking, or mind reading), gently ask questions that help them see the gap between their thought and reality.

Neutrality: Do not take sides or offer personal opinions. Remain an objective mirror.

Safety & Boundaries: Do not diagnose medical conditions. If the user mentions self-harm or severe crisis, prioritize safety resources immediately.

Tone: Professional, calm, curious, and empathetic. Avoid being overly casual or using slang.''';
    }
  }

  /// Analyze journal entry using Gemini
  Future<Map<String, dynamic>?> analyzeJournalEntry(String content) async {
    if (!isConfigured) {
      debugPrint('Gemini API not configured');
      return null;
    }

    if (content.trim().isEmpty) {
      debugPrint('Cannot analyze empty journal content');
      return null;
    }

    debugPrint(
      'Analyzing journal entry with content length: ${content.length}',
    );

    try {
      final url = Uri.parse(
        '$_baseUrl/models/$_model:generateContent?key=$_apiKey',
      );

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    '''Analyze this journal entry and respond with a JSON object only.

Journal entry:
"$content"

Respond with this exact JSON structure:
{"summary": "2-3 sentence summary", "emotion": "one word emotion", "risk": "low/medium/high", "actions": ["action1", "action2"]}

Valid emotions: Happy, Sad, Anxious, Grateful, Reflective, Frustrated, Hopeful, Overwhelmed, Peaceful, Motivated
Actions should be helpful suggestions like "Try deep breathing" or "Take a walk outside"''',
              },
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 2048,
          'topP': 0.95,
          'topK': 40,
        },
      };

      debugPrint('Sending journal analysis request to Gemini...');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint(
        'Gemini journal analysis response status: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        debugPrint('Gemini API error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Gemini raw response: ${response.body}');

      // Extract text from response
      final candidates = jsonResponse['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        debugPrint('No candidates in journal analysis response');
        return null;
      }

      final content0 = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content0?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        debugPrint(
          'Empty parts in journal analysis response. Candidate: ${candidates[0]}',
        );
        return null;
      }

      final text = parts[0]['text'] as String? ?? '';
      debugPrint('Gemini journal analysis text: $text');

      if (text.isEmpty) {
        debugPrint('Empty text in journal analysis response');
        return null;
      }

      // Parse JSON from response
      final jsonMatch = RegExp(
        r'\{[^{}]*(?:\[[^\]]*\][^{}]*)*\}',
        dotAll: true,
      ).firstMatch(text);

      if (jsonMatch != null) {
        var jsonStr = jsonMatch.group(0)!;
        debugPrint('Extracted JSON: $jsonStr');
        jsonStr = jsonStr.replaceAllMapped(
          RegExp(r'"\s*([^"]+?)\s*"\s*:'),
          (match) => '"${match.group(1)!.trim()}":',
        );
        return jsonDecode(jsonStr) as Map<String, dynamic>;
      }

      debugPrint('Could not extract JSON from response: $text');
      return null;
    } catch (e) {
      debugPrint('Error analyzing journal with Gemini: $e');
      return null;
    }
  }
}
