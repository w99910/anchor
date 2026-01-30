import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:executorch_flutter/executorch_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model_download_service.dart';

/// Status of the LLM model
enum LlmModelStatus { notLoaded, loading, ready, error }

/// Inference backend type
enum LlmBackend {
  none,
  executorchFlutter, // Using executorch_flutter package
  nativeRunner, // Using native llama_main binary
  mockResponses, // Fallback mock responses
}

/// Service for managing on-device LLM inference using ExecuTorch
class LlmService extends ChangeNotifier {
  static final LlmService _instance = LlmService._internal();
  factory LlmService() => _instance;
  LlmService._internal();

  // Platform channels for native runner
  static const MethodChannel _nativeChannel = MethodChannel(
    'com.example.anchor/llm',
  );
  static const EventChannel _streamChannel = EventChannel(
    'com.example.anchor/llm_stream',
  );

  ExecuTorchModel? _model;
  LlmTokenizer? _tokenizer;

  LlmModelStatus _status = LlmModelStatus.notLoaded;
  String? _errorMessage;
  double _loadProgress = 0.0;
  LlmBackend _activeBackend = LlmBackend.none;

  // Model configuration
  static const int _maxSeqLen = 2048;
  static const int _vocabSize = 128256; // Llama 3 vocabulary size

  // Model paths (set during loadModel)
  String? _externalModelPath;
  String? _tokenizerPath;

  // Getters
  LlmModelStatus get status => _status;
  String? get errorMessage => _errorMessage;
  double get loadProgress => _loadProgress;
  bool get isReady => _status == LlmModelStatus.ready;
  bool get isLoading => _status == LlmModelStatus.loading;
  LlmBackend get activeBackend => _activeBackend;

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

  /// Generate a response for the given prompt
  Future<String> generateResponse({
    required String prompt,
    required String mode, // 'friend' or 'therapist'
    int maxTokens = 256,
    double temperature = 0.7,
    StreamController<String>? streamController,
  }) async {
    // Build the chat prompt with system message
    final systemPrompt = mode == 'friend'
        ? '''You are a warm, empathetic friend who listens and supports. 
Be conversational, caring, and genuine. Use a friendly tone.
Keep responses concise but meaningful.'''
        : '''You are a compassionate mental health support companion.
Use therapeutic communication techniques like active listening,
validation, and open-ended questions. Be professional yet warm.
Help users explore their feelings without diagnosing.''';

    final fullPrompt =
        '''<|begin_of_text|><|start_header_id|>system<|end_header_id|>

$systemPrompt<|eot_id|><|start_header_id|>user<|end_header_id|>

$prompt<|eot_id|><|start_header_id|>assistant<|end_header_id|>

''';

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

  /// Generate response using native Llama runner with streaming
  Future<String> _generateWithNativeRunner(
    String prompt,
    int maxTokens, {
    StreamController<String>? streamController,
  }) async {
    if (_externalModelPath == null || _tokenizerPath == null) {
      throw Exception('Model or tokenizer path not set');
    }

    try {
      debugPrint('Running native Llama inference (streaming)...');

      final completer = Completer<String>();
      String lastResponse = '';

      // Listen to stream
      final subscription = _streamChannel.receiveBroadcastStream().listen(
        (event) {
          if (event is Map) {
            final type = event['type'] as String?;
            final data = event['data'] as String?;

            debugPrint('Stream event: $type');

            if (type == 'token' && data != null) {
              lastResponse = data;
              streamController?.add(data);
            } else if (type == 'done' && data != null) {
              lastResponse = data;
              if (!completer.isCompleted) {
                completer.complete(data);
              }
            } else if (type == 'status') {
              debugPrint('Status: $data');
            }
          }
        },
        onError: (error) {
          debugPrint('Stream error: $error');
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
        onDone: () {
          debugPrint('Stream done');
          if (!completer.isCompleted) {
            completer.complete(lastResponse);
          }
        },
      );

      // Start inference
      await _nativeChannel.invokeMethod('runLlamaStream', {
        'modelPath': _externalModelPath,
        'tokenizerPath': _tokenizerPath,
        'prompt': prompt,
        'maxSeqLen': maxTokens,
      });

      // Wait for completion with timeout
      final result = await completer.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          subscription.cancel();
          return lastResponse.isNotEmpty ? lastResponse : 'Response timed out';
        },
      );

      await subscription.cancel();
      return result;
    } on PlatformException catch (e) {
      debugPrint('Native runner error: ${e.message}');
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

    // Find the assistant's response after the header
    final assistantMarkerIndex = fullText.lastIndexOf(
      '<|start_header_id|>assistant<|end_header_id|>',
    );
    if (assistantMarkerIndex != -1) {
      fullText = fullText.substring(
        assistantMarkerIndex +
            '<|start_header_id|>assistant<|end_header_id|>'.length,
      );
    }

    // Remove any remaining special tokens and clean up
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
