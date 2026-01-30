import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  /// Download a file with progress tracking using dio
  Future<bool> _downloadFile(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      debugPrint('Downloading: $url');
      debugPrint('Saving to: $savePath');

      final dio = Dio();

      // Configure for better download performance
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(minutes: 30);

      // First get the file size
      final headResponse = await dio.head(url);
      final contentLength =
          int.tryParse(headResponse.headers.value('content-length') ?? '0') ??
          0;
      debugPrint('Content length: $contentLength bytes');

      // For large files (>50MB), use parallel chunk downloads
      if (contentLength > 50 * 1024 * 1024) {
        return await _downloadFileInChunks(
          dio,
          url,
          savePath,
          contentLength,
          onProgress: onProgress,
        );
      }

      // For smaller files, use simple download
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          onProgress?.call(received, total > 0 ? total : contentLength);
        },
      );

      final fileSize = await File(savePath).length();
      debugPrint('Downloaded $fileSize bytes to $savePath');

      return true;
    } catch (e) {
      debugPrint('Download error: $e');
      return false;
    }
  }

  /// Download large file using parallel chunk downloads
  Future<bool> _downloadFileInChunks(
    Dio dio,
    String url,
    String savePath,
    int totalSize, {
    void Function(int received, int total)? onProgress,
    int numChunks = 4, // Number of parallel downloads
  }) async {
    try {
      debugPrint('Starting parallel download with $numChunks chunks');

      final chunkSize = (totalSize / numChunks).ceil();
      final tempDir = Directory('${savePath}_chunks');
      if (!tempDir.existsSync()) {
        await tempDir.create(recursive: true);
      }

      // Track progress for each chunk
      final chunkProgress = List<int>.filled(numChunks, 0);

      void updateTotalProgress() {
        final totalReceived = chunkProgress.reduce((a, b) => a + b);
        onProgress?.call(totalReceived, totalSize);
      }

      // Download chunks in parallel
      final futures = <Future<bool>>[];

      for (int i = 0; i < numChunks; i++) {
        final start = i * chunkSize;
        final end = (i == numChunks - 1)
            ? totalSize - 1
            : (start + chunkSize - 1);
        final chunkPath = '${tempDir.path}/chunk_$i';

        futures.add(
          _downloadChunk(
            dio,
            url,
            chunkPath,
            start,
            end,
            onProgress: (received) {
              chunkProgress[i] = received;
              updateTotalProgress();
            },
          ),
        );
      }

      // Wait for all chunks to complete
      final results = await Future.wait(futures);

      if (results.any((success) => !success)) {
        debugPrint('Some chunks failed to download');
        await tempDir.delete(recursive: true);
        return false;
      }

      // Merge chunks into final file
      debugPrint('Merging chunks...');
      final outputFile = File(savePath);
      final sink = outputFile.openWrite();

      for (int i = 0; i < numChunks; i++) {
        final chunkFile = File('${tempDir.path}/chunk_$i');
        await sink.addStream(chunkFile.openRead());
      }

      await sink.close();

      // Cleanup temp chunks
      await tempDir.delete(recursive: true);

      final fileSize = await outputFile.length();
      debugPrint('Merged file size: $fileSize bytes');

      return fileSize == totalSize;
    } catch (e) {
      debugPrint('Chunk download error: $e');
      return false;
    }
  }

  /// Download a single chunk with range request
  Future<bool> _downloadChunk(
    Dio dio,
    String url,
    String savePath,
    int start,
    int end, {
    void Function(int received)? onProgress,
  }) async {
    try {
      debugPrint('Downloading chunk: $start-$end');

      await dio.download(
        url,
        savePath,
        options: Options(headers: {'Range': 'bytes=$start-$end'}),
        onReceiveProgress: (received, total) {
          onProgress?.call(received);
        },
      );

      return true;
    } catch (e) {
      debugPrint('Chunk $start-$end error: $e');
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
