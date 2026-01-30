import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Status of model download
enum ModelDownloadStatus {
  notDownloaded,
  checking,
  downloading,
  downloaded,
  error,
}

/// Service for downloading and managing the LLM model files
class ModelDownloadService extends ChangeNotifier {
  static final ModelDownloadService _instance =
      ModelDownloadService._internal();
  factory ModelDownloadService() => _instance;
  ModelDownloadService._internal();

  // Hugging Face URLs for the pre-exported SpinQuant model
  static const String _modelUrl =
      'https://huggingface.co/executorch-community/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8-ET/resolve/main/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8.pte';
  static const String _tokenizerUrl =
      'https://huggingface.co/executorch-community/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8-ET/resolve/main/tokenizer.model';

  static const String _modelFileName = 'llama.pte';
  static const String _tokenizerFileName = 'tokenizer.model';
  static const String _prefsKeyModelDownloaded = 'model_downloaded_v1';

  ModelDownloadStatus _status = ModelDownloadStatus.notDownloaded;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  int _totalBytes = 0;
  int _downloadedBytes = 0;

  // Getters
  ModelDownloadStatus get status => _status;
  double get downloadProgress => _downloadProgress;
  String? get errorMessage => _errorMessage;
  int get totalBytes => _totalBytes;
  int get downloadedBytes => _downloadedBytes;
  bool get isDownloaded => _status == ModelDownloadStatus.downloaded;
  bool get isDownloading => _status == ModelDownloadStatus.downloading;

  /// Get the directory where model files are stored
  Future<Directory> getModelDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${appDir.path}/llm_models');
    if (!modelDir.existsSync()) {
      await modelDir.create(recursive: true);
    }
    return modelDir;
  }

  /// Get path to the downloaded model file
  Future<String> getModelPath() async {
    final dir = await getModelDirectory();
    return '${dir.path}/$_modelFileName';
  }

  /// Get path to the downloaded tokenizer file
  Future<String> getTokenizerPath() async {
    final dir = await getModelDirectory();
    return '${dir.path}/$_tokenizerFileName';
  }

  /// Check if model is already downloaded
  Future<bool> isModelDownloaded() async {
    try {
      final modelPath = await getModelPath();
      final tokenizerPath = await getTokenizerPath();

      final modelFile = File(modelPath);
      final tokenizerFile = File(tokenizerPath);

      // Check if both files exist and have reasonable sizes
      if (modelFile.existsSync() && tokenizerFile.existsSync()) {
        final modelSize = await modelFile.length();
        final tokenizerSize = await tokenizerFile.length();

        // Model should be > 1GB, tokenizer > 1MB
        if (modelSize > 1000000000 && tokenizerSize > 1000000) {
          debugPrint(
            'Model files found: model=${modelSize}B, tokenizer=${tokenizerSize}B',
          );
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error checking model: $e');
      return false;
    }
  }

  /// Initialize and check model status
  Future<void> initialize() async {
    _status = ModelDownloadStatus.checking;
    notifyListeners();

    final downloaded = await isModelDownloaded();

    if (downloaded) {
      _status = ModelDownloadStatus.downloaded;
      debugPrint('Model already downloaded');
    } else {
      _status = ModelDownloadStatus.notDownloaded;
      debugPrint('Model not downloaded');
    }

    notifyListeners();
  }

  /// Download the model and tokenizer files
  Future<bool> downloadModel({
    void Function(double progress, String message)? onProgress,
  }) async {
    if (_status == ModelDownloadStatus.downloading) {
      debugPrint('Download already in progress');
      return false;
    }

    _status = ModelDownloadStatus.downloading;
    _downloadProgress = 0.0;
    _errorMessage = null;
    _totalBytes = 0;
    _downloadedBytes = 0;
    notifyListeners();

    try {
      final modelDir = await getModelDirectory();
      final modelPath = '${modelDir.path}/$_modelFileName';
      final tokenizerPath = '${modelDir.path}/$_tokenizerFileName';

      // Download tokenizer first (smaller file)
      onProgress?.call(0.01, 'Downloading tokenizer...');
      _updateProgress(0.01, 'Downloading tokenizer...');

      final tokenizerSuccess = await _downloadFile(
        _tokenizerUrl,
        tokenizerPath,
        onProgress: (received, total) {
          // Tokenizer is ~2MB, allocate 2% of progress
          final progress = 0.01 + (received / total) * 0.02;
          _updateProgress(progress, 'Downloading tokenizer...');
          onProgress?.call(progress, 'Downloading tokenizer...');
        },
      );

      if (!tokenizerSuccess) {
        throw Exception('Failed to download tokenizer');
      }

      // Download model (large file ~1.1GB)
      onProgress?.call(0.03, 'Downloading model (1.1GB)...');
      _updateProgress(0.03, 'Downloading model (1.1GB)...');

      final modelSuccess = await _downloadFile(
        _modelUrl,
        modelPath,
        onProgress: (received, total) {
          // Model is 98% of the download
          final progress = 0.03 + (received / total) * 0.97;
          _downloadedBytes = received;
          _totalBytes = total;
          final mbDownloaded = (received / 1024 / 1024).toStringAsFixed(1);
          final mbTotal = (total / 1024 / 1024).toStringAsFixed(1);
          _updateProgress(
            progress,
            'Downloading model: $mbDownloaded / $mbTotal MB',
          );
          onProgress?.call(
            progress,
            'Downloading model: $mbDownloaded / $mbTotal MB',
          );
        },
      );

      if (!modelSuccess) {
        throw Exception('Failed to download model');
      }

      // Verify downloads
      final verified = await isModelDownloaded();
      if (!verified) {
        throw Exception('Downloaded files are incomplete or corrupted');
      }

      // Save download status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKeyModelDownloaded, true);

      _status = ModelDownloadStatus.downloaded;
      _downloadProgress = 1.0;
      notifyListeners();

      debugPrint('Model download complete');
      return true;
    } catch (e) {
      _status = ModelDownloadStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Model download error: $e');
      return false;
    }
  }

  /// Download a file with progress tracking
  Future<bool> _downloadFile(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      debugPrint('Downloading: $url');
      debugPrint('Saving to: $savePath');

      final request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        debugPrint('Download failed with status: ${response.statusCode}');
        return false;
      }

      final contentLength = response.contentLength ?? 0;
      debugPrint('Content length: $contentLength bytes');

      final file = File(savePath);
      final sink = file.openWrite();

      int received = 0;
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(
          received,
          contentLength > 0 ? contentLength : received,
        );
      }

      await sink.close();

      final fileSize = await file.length();
      debugPrint('Downloaded $fileSize bytes to $savePath');

      return true;
    } catch (e) {
      debugPrint('Download error: $e');
      return false;
    }
  }

  void _updateProgress(double progress, String message) {
    _downloadProgress = progress;
    debugPrint(
      'Download progress: ${(progress * 100).toStringAsFixed(1)}% - $message',
    );
    notifyListeners();
  }

  /// Delete downloaded model files
  Future<void> deleteModel() async {
    try {
      final modelPath = await getModelPath();
      final tokenizerPath = await getTokenizerPath();

      final modelFile = File(modelPath);
      final tokenizerFile = File(tokenizerPath);

      if (modelFile.existsSync()) {
        await modelFile.delete();
      }
      if (tokenizerFile.existsSync()) {
        await tokenizerFile.delete();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKeyModelDownloaded, false);

      _status = ModelDownloadStatus.notDownloaded;
      _downloadProgress = 0.0;
      notifyListeners();

      debugPrint('Model files deleted');
    } catch (e) {
      debugPrint('Error deleting model: $e');
    }
  }

  /// Get human-readable file size
  String getFormattedSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }
}
