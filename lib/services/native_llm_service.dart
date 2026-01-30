import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Service for running Llama inference via native ExecuTorch runner
class NativeLlmService {
  static const MethodChannel _channel = MethodChannel('com.example.anchor/llm');

  static final NativeLlmService _instance = NativeLlmService._internal();
  factory NativeLlmService() => _instance;
  NativeLlmService._internal();

  String? _modelPath;
  String? _tokenizerPath;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the service with model and tokenizer paths
  Future<void> initialize({
    required String modelPath,
    required String tokenizerPath,
  }) async {
    _modelPath = modelPath;
    _tokenizerPath = tokenizerPath;

    // Verify files exist
    if (!File(modelPath).existsSync()) {
      throw Exception('Model file not found: $modelPath');
    }
    if (!File(tokenizerPath).existsSync()) {
      throw Exception('Tokenizer file not found: $tokenizerPath');
    }

    _isInitialized = true;
    debugPrint('NativeLlmService initialized with model: $modelPath');
  }

  /// Get the native library directory (Android only)
  Future<String?> getNativeLibPath() async {
    if (!Platform.isAndroid) return null;

    try {
      final path = await _channel.invokeMethod<String>('getNativeLibPath');
      debugPrint('Native lib path: $path');
      return path;
    } catch (e) {
      debugPrint('Error getting native lib path: $e');
      return null;
    }
  }

  /// Check if the native Llama binary is available
  Future<bool> isNativeLlamaAvailable() async {
    if (!Platform.isAndroid) return false;

    try {
      final nativeLibPath = await getNativeLibPath();
      if (nativeLibPath == null) return false;

      final binaryPath = '$nativeLibPath/llama_main';
      return File(binaryPath).existsSync();
    } catch (e) {
      debugPrint('Error checking native Llama: $e');
      return false;
    }
  }

  /// Run Llama inference with the given prompt
  Future<String> generateResponse({
    required String prompt,
    int maxSeqLen = 256,
  }) async {
    if (!_isInitialized) {
      throw Exception('NativeLlmService not initialized');
    }

    if (!Platform.isAndroid) {
      throw Exception('Native Llama is only supported on Android');
    }

    try {
      debugPrint('Running native Llama inference...');
      debugPrint('Model: $_modelPath');
      debugPrint('Tokenizer: $_tokenizerPath');
      debugPrint('Prompt: $prompt');

      final result = await _channel.invokeMethod<String>('runLlama', {
        'modelPath': _modelPath,
        'tokenizerPath': _tokenizerPath,
        'prompt': prompt,
        'maxSeqLen': maxSeqLen,
      });

      debugPrint('Llama result: $result');
      return result ?? '';
    } on PlatformException catch (e) {
      debugPrint('Platform exception: ${e.message}');
      debugPrint('Details: ${e.details}');
      rethrow;
    }
  }

  /// Stop any running Llama inference
  Future<void> stop() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('stopLlama');
    } catch (e) {
      debugPrint('Error stopping Llama: $e');
    }
  }

  /// Find model files on the device
  static Future<Map<String, String?>> findModelFiles() async {
    String? modelPath;
    String? tokenizerPath;

    // Check common locations
    final locations = <String>[];

    if (Platform.isAndroid) {
      locations.addAll(['/sdcard/Download', '/storage/emulated/0/Download']);

      // Also check app's external storage
      try {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          locations.add(extDir.path);
          locations.add('${extDir.path}/models');
        }
      } catch (e) {
        debugPrint('Error getting external storage: $e');
      }
    }

    // Check app documents directory
    try {
      final docDir = await getApplicationDocumentsDirectory();
      locations.add(docDir.path);
      locations.add('${docDir.path}/models');
    } catch (e) {
      debugPrint('Error getting documents directory: $e');
    }

    // Look for model files
    for (final location in locations) {
      final dir = Directory(location);
      if (!dir.existsSync()) continue;

      try {
        for (final file in dir.listSync()) {
          if (file is File) {
            final name = file.path.split('/').last;
            if (name.endsWith('.pte') && modelPath == null) {
              modelPath = file.path;
              debugPrint('Found model: $modelPath');
            }
            if (name == 'tokenizer.model' && tokenizerPath == null) {
              tokenizerPath = file.path;
              debugPrint('Found tokenizer: $tokenizerPath');
            }
          }
        }
      } catch (e) {
        debugPrint('Error listing directory $location: $e');
      }
    }

    return {'model': modelPath, 'tokenizer': tokenizerPath};
  }
}
