import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:executorch_flutter/executorch_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_settings_service.dart';
import 'gemini_service.dart';
import 'model_download_service.dart';
import 'user_info_service.dart';

/// Data class to pass to isolate
class _InferenceRequest {
  final String modelPath;
  final String tokenizerPath;
  final String prompt;
  final int maxTokens;
  final RootIsolateToken rootIsolateToken;
  final SendPort sendPort;

  _InferenceRequest({
    required this.modelPath,
    required this.tokenizerPath,
    required this.prompt,
    required this.maxTokens,
    required this.rootIsolateToken,
    required this.sendPort,
  });
}

/// Run inference in a background isolate
Future<void> _runInferenceInIsolate(_InferenceRequest request) async {
  debugPrint(
    '[BG_ISOLATE] Running in background isolate: ${Isolate.current.hashCode}',
  );

  // Register the background isolate with the root isolate's binary messenger
  BackgroundIsolateBinaryMessenger.ensureInitialized(request.rootIsolateToken);
  debugPrint('[BG_ISOLATE] Binary messenger initialized');

  const channel = MethodChannel('com.example.anchor/llm');

  try {
    debugPrint('[BG_ISOLATE] Calling platform channel...');
    final result = await channel.invokeMethod<String>('runLlama', {
      'modelPath': request.modelPath,
      'tokenizerPath': request.tokenizerPath,
      'prompt': request.prompt,
      'maxSeqLen': request.maxTokens,
    });
    debugPrint('[BG_ISOLATE] Got result, sending back to main isolate');
    request.sendPort.send({'success': true, 'result': result});
  } catch (e) {
    debugPrint('[BG_ISOLATE] Error: $e');
    request.sendPort.send({'success': false, 'error': e.toString()});
  }
}

/// Status of the LLM model
enum LlmModelStatus { notLoaded, loading, ready, error }

/// Inference backend type
enum LlmBackend {
  none,
  executorchFlutter, // Using executorch_flutter package
  nativeRunner, // Using native llama_main binary
  mockResponses, // Fallback mock responses
  geminiCloud, // Cloud Gemini API
}

/// Service for managing on-device LLM inference using ExecuTorch
class LlmService extends ChangeNotifier {
  static final LlmService _instance = LlmService._internal();
  factory LlmService() => _instance;
  LlmService._internal();

  // Platform channel for native runner
  static const MethodChannel _nativeChannel = MethodChannel(
    'com.example.anchor/llm',
  );

  // AI settings and Gemini services
  final _aiSettings = AiSettingsService();
  final _geminiService = GeminiService();

  ExecuTorchModel? _model;
  LlmTokenizer? _tokenizer;

  LlmModelStatus _status = LlmModelStatus.notLoaded;
  String? _errorMessage;
  double _loadProgress = 0.0;
  LlmBackend _activeBackend = LlmBackend.none;

  // Model configuration
  static const int _maxSeqLen = 2048;
  static const int _llamaVocabSize = 128256; // Llama vocabulary size
  static const int _qwenVocabSize = 151936; // Qwen3 vocabulary size

  // Track which model is loaded (true = Qwen/ChatML format, false = Llama format)
  // bool _isQwenModel = false;
  bool _useAdvanceModel = false;

  // Model paths (set during loadModel)
  String? _externalModelPath;
  String? _tokenizerPath;

  // Getters
  LlmModelStatus get status => _status;
  String? get errorMessage => _errorMessage;
  double get loadProgress => _loadProgress;
  bool get isReady => _status == LlmModelStatus.ready || isCloudProviderReady;
  bool get isLoading => _status == LlmModelStatus.loading;
  LlmBackend get activeBackend =>
      _aiSettings.isCloudProvider && _geminiService.isConfigured
      ? LlmBackend.geminiCloud
      : _activeBackend;

  /// Returns true if cloud provider is selected and ready
  bool get isCloudProviderReady =>
      _aiSettings.isCloudProvider && _geminiService.isConfigured;

  /// Returns true if using cloud provider
  bool get isUsingCloudProvider => _aiSettings.isCloudProvider;

  /// Returns true if a real AI model is loaded (not mock responses)
  bool get hasRealAI =>
      isCloudProviderReady ||
      (_status == LlmModelStatus.ready &&
          (_activeBackend == LlmBackend.nativeRunner ||
              _activeBackend == LlmBackend.executorchFlutter));

  /// Returns true if Qwen model is loaded, false for Llama
  bool get useAdvancedModel => _useAdvanceModel;

  /// Set an external model path (for models not bundled with the app)
  void setExternalModelPath(String path) {
    _externalModelPath = path;
  }

  /// Check if native Llama runner is available (Android only)
  Future<bool> isNativeRunnerAvailable() async {
    if (!Platform.isAndroid) return false;

    try {
      final isAvailable = await _nativeChannel.invokeMethod<bool>(
        'isNativeRunnerAvailable',
      );
      debugPrint('Native runner available: $isAvailable');
      return isAvailable ?? false;
    } catch (e) {
      debugPrint('Error checking native runner: $e');
      return false;
    }
  }

  /// Check if model is available in app storage
  Future<bool> isModelAvailable() async {
    final downloadService = ModelDownloadService();
    return await downloadService.isModelDownloaded();
  }

  /// Load the LLM model
  Future<void> loadModel() async {
    if (_status == LlmModelStatus.loading) return;

    _status = LlmModelStatus.loading;
    _errorMessage = null;
    _loadProgress = 0.0;
    _activeBackend = LlmBackend.none;
    notifyListeners();

    try {
      _updateProgress(0.1, 'Checking model...');

      // Check if model is downloaded to app storage
      final downloadService = ModelDownloadService();
      final isDownloaded = await downloadService.isModelDownloaded();

      if (!isDownloaded) {
        // Model not in app storage - use demo mode, user needs to download
        debugPrint('Model not downloaded to app storage');
        _activeBackend = LlmBackend.mockResponses;
        _updateProgress(1.0, 'Demo mode - download model for AI');
        _status = LlmModelStatus.ready;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('llm_model_loaded', false);
        notifyListeners();
        return;
      }

      // Model is downloaded - use it from app storage
      final modelPath = await downloadService.getModelPath();
      final tokenizerPath = await downloadService.getTokenizerPath();
      _externalModelPath = modelPath;
      _tokenizerPath = tokenizerPath;
      _useAdvanceModel = downloadService.useAdvancedModel;

      debugPrint('Model path: $modelPath');
      debugPrint('Tokenizer path: $tokenizerPath');

      _updateProgress(0.3, 'Initializing...');

      // Try native runner (Android only)
      if (Platform.isAndroid) {
        final hasNativeRunner = await isNativeRunnerAvailable();

        if (hasNativeRunner) {
          debugPrint('Using native Llama runner');
          _activeBackend = LlmBackend.nativeRunner;
          _updateProgress(1.0, 'Ready');
          _status = LlmModelStatus.ready;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('llm_model_loaded', true);
          notifyListeners();
          return;
        }
      }

      // Fallback to ExecuTorch Flutter (won't work with SpinQuant but try anyway)
      _updateProgress(0.5, 'Loading model...');
      try {
        debugPrint('Loading model with ExecuTorch Flutter: $modelPath');
        _model = await ExecuTorchModel.load(modelPath);
        _activeBackend = LlmBackend.executorchFlutter;

        _updateProgress(0.9, 'Initializing tokenizer...');
        _tokenizer = LlmTokenizer();
        await _tokenizer!.initialize();

        _updateProgress(1.0, 'Ready');
        _status = LlmModelStatus.ready;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('llm_model_loaded', true);
      } catch (e) {
        debugPrint('ExecuTorch Flutter failed: $e');
        _activeBackend = LlmBackend.mockResponses;
        _updateProgress(1.0, 'Demo mode');
        _status = LlmModelStatus.ready;
        _errorMessage = 'Model loading failed: $e';
      }
    } catch (e, stackTrace) {
      _status = LlmModelStatus.error;
      _errorMessage = e.toString();
      _activeBackend = LlmBackend.none;
      debugPrint('Error loading LLM model: $e');
      debugPrint('Stack trace: $stackTrace');
    }

    notifyListeners();
  }

  void _updateProgress(double progress, String message) {
    _loadProgress = progress;
    debugPrint('LLM Load Progress: ${(progress * 100).toInt()}% - $message');
    notifyListeners();
  }

  /// Format prompt using Llama chat template
  String _formatLlamaPrompt(String systemPrompt, String userPrompt) {
    return '''<|begin_of_text|><|start_header_id|>system<|end_header_id|>

$systemPrompt<|eot_id|><|start_header_id|>user<|end_header_id|>

$userPrompt<|eot_id|><|start_header_id|>assistant<|end_header_id|>

''';
  }

  /// Format prompt using Llama chat template with conversation history
  String _formatLlamaPromptWithHistory(
    String systemPrompt,
    List<Map<String, String>>? chatHistory,
    String userPrompt,
  ) {
    final buffer = StringBuffer();
    buffer.write(
      '<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n',
    );
    buffer.write('$systemPrompt<|eot_id|>');

    // Add conversation history
    if (chatHistory != null && chatHistory.isNotEmpty) {
      for (final message in chatHistory) {
        final role = message['role'] == 'user' ? 'user' : 'assistant';
        final content = message['content'] ?? '';
        buffer.write(
          '<|start_header_id|>$role<|end_header_id|>\n\n$content<|eot_id|>',
        );
      }
    }

    // Add current user message
    buffer.write(
      '<|start_header_id|>user<|end_header_id|>\n\n$userPrompt<|eot_id|>',
    );
    buffer.write('<|start_header_id|>assistant<|end_header_id|>\n\n');

    return buffer.toString();
  }

  /// Format prompt using Qwen chat template (ChatML format)
  /// Works with Qwen 2.5, Qwen3, and other ChatML-compatible models
  String _formatQwenPrompt(String systemPrompt, String userPrompt) {
    return '''<|im_start|>system
'/no_think'
$systemPrompt<|im_end|>
<|im_start|>user
$userPrompt<|im_end|>
<|im_start|>assistant
''';
  }

  /// Get the current vocabulary size based on model type
  int get _vocabSize => _useAdvanceModel ? _qwenVocabSize : _llamaVocabSize;

  /// Generate a response for the given prompt
  Future<String> generateResponse({
    required String prompt,
    required String mode, // 'friend' or 'therapist'
    List<Map<String, String>>?
    chatHistory, // Previous messages in format [{"role": "user"/"assistant", "content": "..."}]
    int maxTokens = 256,
    double temperature = 0.7,
    StreamController<String>? streamController,
  }) async {
    // Check if cloud provider is selected and available
    if (_aiSettings.isCloudProvider && _geminiService.isConfigured) {
      debugPrint('Using Gemini cloud provider for response');
      return _geminiService.generateResponse(
        prompt: prompt,
        mode: mode,
        chatHistory: chatHistory,
        maxTokens: maxTokens,
        temperature: temperature,
        streamController: streamController,
      );
    }

    // Get user context for personalization
    final userContext = UserInfoService().getUserContext();

    // Build the chat prompt with system message for on-device model
    final systemPrompt = mode == 'friend'
        ? '''You are a warm, genuine, and supportive friend. You are NOT a clinical therapist.

Guidelines:

Active Reassurance: Do not just reflect the user's feelings back to them. You must actively validate them. If they share a negative thought (like 'I'm a failure'), explicitly tell them that one mistake does not define them.

Normalize: Remind the user that their struggles (like burnout or missing deadlines) are a normal part of being human.

Conversational Tone: Speak naturally. Use phrases like 'I get it,' 'That is so heavy,' or 'I'm here for you.'

Less Asking, More Sharing: Do not end every message with a question. Sometimes, just sitting with the emotion is enough. If you do ask a question, make it casual.

When speaking in other language, do not translate English idioms literally.$userContext'''
        : '''Role: You are a compassionate, professional, and non-judgmental AI therapist. You draw upon techniques from Cognitive Behavioral Therapy (CBT) and Person-Centered Therapy.

Core Objective: Your goal is not to "fix" the user or give direct advice, but to help them explore their emotions, identify cognitive distortions (negative thought patterns), and find their own clarity.

Guidelines:

Reflective Listening: Start by validating the user's feelings to establish safety (e.g., "It sounds like you're carrying a heavy burden...").

Socratic Questioning: Use open-ended, probing questions to help the user examine the evidence for their beliefs. (e.g., "What evidence do you have that supports this fear? Is there evidence that contradicts it?")

Identify Distortions: If the user exhibits common cognitive distortions (like catastrophizing, all-or-nothing thinking, or mind reading), gently ask questions that help them see the gap between their thought and reality.

Neutrality: Do not take sides or offer personal opinions. Remain an objective mirror.

Safety & Boundaries: Do not diagnose medical conditions. If the user mentions self-harm or severe crisis, prioritize safety resources immediately.

Tone: Professional, calm, curious, and empathetic. Avoid being overly casual or using slang.

Lanaguage: When speaking in other language, do not translate English idioms literally.$userContext''';

    // Format prompt based on model type, including chat history
    final fullPrompt = _formatLlamaPromptWithHistory(
      systemPrompt,
      chatHistory,
      prompt,
    );

    // Use native runner if available
    if (_activeBackend == LlmBackend.nativeRunner) {
      return _generateWithNativeRunner(
        fullPrompt,
        maxTokens,
        streamController: streamController,
      );
    }

    // Use mock responses as fallback
    if (_activeBackend == LlmBackend.mockResponses || _model == null) {
      return _generateMockResponse(prompt, mode);
    }

    // Otherwise use executorch_flutter
    if (_model == null || _tokenizer == null) {
      throw Exception('Model not loaded');
    }

    // Tokenize the prompt
    final inputTokens = _tokenizer!.encode(fullPrompt);

    // Generate response tokens
    final responseTokens = <int>[];
    var currentTokens = List<int>.from(inputTokens);

    for (int i = 0; i < maxTokens; i++) {
      // Prepare input tensor
      final inputTensor = _prepareInputTensor(currentTokens);

      // Run inference
      final outputs = await _model!.forward([inputTensor]);

      if (outputs.isEmpty) {
        break;
      }

      // Get the next token from logits
      final logits = _extractLogits(outputs[0]);
      final nextToken = _sampleToken(logits, temperature);

      // Check for end of sequence
      if (_tokenizer!.isEndOfSequence(nextToken)) {
        break;
      }

      responseTokens.add(nextToken);
      currentTokens.add(nextToken);

      // Stream the token if streaming is enabled
      if (streamController != null) {
        final partialText = _tokenizer!.decode(responseTokens);
        streamController.add(partialText);
      }

      // Truncate if exceeding max sequence length
      if (currentTokens.length >= _maxSeqLen) {
        break;
      }
    }

    // Decode and return the response
    final response = _tokenizer!.decode(responseTokens);
    return response.trim();
  }

  TensorData _prepareInputTensor(List<int> tokens) {
    // Create input tensor from token IDs
    final tokenBytes = Int32List.fromList(tokens);
    return TensorData(
      shape: [1, tokens.length],
      dataType: TensorType.int32,
      data: tokenBytes.buffer.asUint8List(),
      name: 'input_ids',
    );
  }

  List<double> _extractLogits(TensorData output) {
    // Extract logits from the output tensor
    // Assuming output shape is [1, seq_len, vocab_size]
    final bytes = output.data;
    final floats = bytes.buffer.asFloat32List();

    // Get the last position's logits (for next token prediction)
    final vocabSize = _vocabSize;
    final lastPositionStart = floats.length - vocabSize;

    if (lastPositionStart < 0) {
      // If output is smaller, return what we have
      return floats.toList();
    }

    return floats.sublist(lastPositionStart).toList();
  }

  int _sampleToken(List<double> logits, double temperature) {
    if (logits.isEmpty) return 0;

    // Apply temperature
    final scaledLogits = logits.map((l) => l / temperature).toList();

    // Softmax
    final maxLogit = scaledLogits.reduce(max);
    final expLogits = scaledLogits.map((l) => exp(l - maxLogit)).toList();
    final sumExp = expLogits.reduce((a, b) => a + b);
    final probs = expLogits.map((e) => e / sumExp).toList();

    // Sample from distribution
    final random = Random();
    final r = random.nextDouble();
    var cumsum = 0.0;

    for (int i = 0; i < probs.length; i++) {
      cumsum += probs[i];
      if (r <= cumsum) {
        return i;
      }
    }

    return probs.length - 1;
  }

  /// Generate response using native Llama runner in a background isolate
  Future<String> _generateWithNativeRunner(
    String prompt,
    int maxTokens, {
    StreamController<String>? streamController,
  }) async {
    if (_externalModelPath == null || _tokenizerPath == null) {
      throw Exception('Model or tokenizer path not set');
    }

    try {
      debugPrint(
        '[MAIN] Starting inference - main isolate: ${Isolate.current.hashCode}',
      );

      // Get the root isolate token for background isolate communication
      final rootIsolateToken = RootIsolateToken.instance;
      if (rootIsolateToken == null) {
        throw Exception('Could not get RootIsolateToken');
      }
      debugPrint('[MAIN] Got RootIsolateToken');

      // Create a receive port to get the result
      final receivePort = ReceivePort();

      // Spawn the isolate - this returns immediately
      debugPrint('[MAIN] Spawning background isolate...');
      await Isolate.spawn(
        _runInferenceInIsolate,
        _InferenceRequest(
          modelPath: _externalModelPath!,
          tokenizerPath: _tokenizerPath!,
          prompt: prompt,
          maxTokens: maxTokens,
          rootIsolateToken: rootIsolateToken,
          sendPort: receivePort.sendPort,
        ),
      );
      debugPrint('[MAIN] Isolate spawned! UI should be responsive now...');

      // Wait for the result - this is async, should not block UI
      final response = await receivePort.first as Map<dynamic, dynamic>;
      debugPrint('[MAIN] Got response from background isolate');
      receivePort.close();

      if (response['success'] == true) {
        final result = response['result'] as String?;
        final parsed = _parseNativeOutput(result ?? '');
        debugPrint(
          'Isolate inference complete: ${parsed.substring(0, min(50, parsed.length))}...',
        );
        return parsed;
      } else {
        debugPrint('Isolate inference error: ${response['error']}');
        return _generateMockResponse(prompt, 'friend');
      }
    } catch (e) {
      debugPrint('Native runner error: $e');
      return _generateMockResponse(prompt, 'friend');
    }
  }

  /// Parse output from native llama_main
  String _parseNativeOutput(String output) {
    // The native runner outputs text interleaved with log lines
    // Log lines look like: "I 00:00:03.042659 executorch:..."
    // Text can appear before log timestamps on the same line

    debugPrint('Raw native output length: ${output.length}');

    // Split into lines
    final lines = output.split('\n');
    final textParts = <String>[];

    for (final line in lines) {
      // Skip pure log/metadata lines
      if (line.startsWith('I tokenizers:') ||
          line.startsWith('PyTorchObserver') ||
          line.startsWith('E tokenizers:') ||
          line.trim().isEmpty) {
        continue;
      }

      // Skip lines that start with log pattern (I/E/W followed by timestamp)
      if (RegExp(r'^[IEW]\s+\d{2}:\d{2}').hasMatch(line)) {
        continue;
      }

      // Extract text before any embedded log line (I 00:00:...)
      String textPart = line;
      final logMatch = RegExp(
        r'[IEW]\s+\d{2}:\d{2}:\d{2}\.\d+',
      ).firstMatch(line);
      if (logMatch != null) {
        textPart = line.substring(0, logMatch.start);
      }

      if (textPart.trim().isNotEmpty) {
        textParts.add(textPart.trim());
      }
    }

    // Join all text parts
    String fullText = textParts.join(' ').trim();

    debugPrint('Joined text (before parsing): $fullText');
    // Llama uses <|start_header_id|>assistant<|end_header_id|> format
    final assistantMarkerIndex = fullText.lastIndexOf(
      '<|start_header_id|>assistant<|end_header_id|>',
    );
    if (assistantMarkerIndex != -1) {
      fullText = fullText.substring(
        assistantMarkerIndex +
            '<|start_header_id|>assistant<|end_header_id|>'.length,
      );
    }

    // Remove Llama special tokens
    fullText = fullText
        .replaceAll('<|eot_id|>', '')
        .replaceAll('Reached to the end of generation', '')
        .replaceAll('<|end_of_text|>', '')
        .replaceAll('<|begin_of_text|>', '')
        .replaceAll(RegExp(r'<\|start_header_id\|>\w+<\|end_header_id\|>'), '')
        .trim();

    // If no special tokens found, try to find the response after the prompt
    // The prompt is echoed first, then the response follows
    if (fullText.isEmpty && textParts.isNotEmpty) {
      // Just return the cleaned text parts
      fullText = textParts.join(' ').trim();
    }

    debugPrint(
      'Parsed response: ${fullText.substring(0, fullText.length.clamp(0, 100))}...',
    );
    return fullText;
  }

  /// Generate a mock response when model is not available
  String _generateMockResponse(String prompt, String mode) {
    if (mode == 'friend') {
      final responses = [
        "Thanks for sharing that with me! I'm here to listen and support you. 😊",
        "I hear you. That sounds like a lot to deal with. How are you feeling about it?",
        "I appreciate you opening up to me. What's been on your mind lately?",
        "That makes sense. It's okay to feel that way. I'm here for you.",
      ];
      return responses[DateTime.now().second % responses.length];
    } else {
      final responses = [
        "Thank you for sharing that. It takes courage to express these feelings. What do you think might be contributing to this?",
        "I appreciate you opening up. Let's explore that together. Can you tell me more about when you first noticed this?",
        "That sounds challenging. It's important to acknowledge these feelings. What would feel supportive for you right now?",
        "I hear what you're saying. Let's take a moment to understand this better. What would a good outcome look like for you?",
      ];
      return responses[DateTime.now().second % responses.length];
    }
  }

  /// Dispose of the model
  @override
  Future<void> dispose() async {
    await _model?.dispose();
    _model = null;
    _tokenizer = null;
    _status = LlmModelStatus.notLoaded;
    super.dispose();
  }
}

/// Simple tokenizer for Llama models
///
/// Note: This is a simplified implementation. For production use,
/// consider using a proper SentencePiece binding or the full
/// tokenizer implementation.
class LlmTokenizer {
  // Llama 3 special tokens
  static const int _bosTokenId = 128000;
  static const int _eosTokenId = 128001;
  static const int _eotTokenId = 128009; // End of turn

  bool _initialized = false;

  // Simple vocabulary mapping (loaded from config)
  // TODO: Implement proper SentencePiece tokenizer loading
  // ignore: unused_field
  final Map<String, int> _vocab = {};
  // ignore: unused_field
  final Map<int, String> _reverseVocab = {};

  Future<void> initialize() async {
    // In a full implementation, load the SentencePiece model
    // For now, we'll use a simplified byte-level tokenizer
    _initialized = true;
    debugPrint('Tokenizer initialized (simplified mode)');
  }

  /// Encode text to token IDs
  List<int> encode(String text) {
    if (!_initialized) {
      throw Exception('Tokenizer not initialized');
    }

    // Simplified UTF-8 byte tokenizer
    // In production, use SentencePiece for proper tokenization
    final bytes = text.codeUnits;
    final tokens = <int>[_bosTokenId];

    // Simple character-level encoding as fallback
    // Real implementation would use SentencePiece BPE
    for (final byte in bytes) {
      // Map to vocabulary (simplified - assumes byte-level tokens)
      tokens.add(byte);
    }

    return tokens;
  }

  /// Decode token IDs to text
  String decode(List<int> tokens) {
    if (!_initialized) {
      throw Exception('Tokenizer not initialized');
    }

    // Filter out special tokens and decode
    final filteredTokens = tokens
        .where(
          (t) =>
              t != _bosTokenId &&
              t != _eosTokenId &&
              t != _eotTokenId &&
              t < 256, // Only decode byte-level tokens
        )
        .toList();

    // Convert back to string
    return String.fromCharCodes(filteredTokens);
  }

  /// Check if token is end of sequence
  bool isEndOfSequence(int tokenId) {
    return tokenId == _eosTokenId || tokenId == _eotTokenId;
  }
}
