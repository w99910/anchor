import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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

  // Model configurations based on RAM capacity
  // Advanced AI model (~2.66GB) - for devices with enough RAM (Qwen3-4B)
  static const String _advancedModelUrl =
      'https://huggingface.co/pytorch/Qwen3-4B-INT8-INT4/resolve/main/model.pte';
  static const String _advancedTokenizerUrl =
      'https://huggingface.co/pytorch/Qwen3-4B-INT8-INT4/resolve/main/tokenizer.json';

  // Compact AI model (~1.1GB) - for devices with less RAM (Llama 3.2 1B)
  static const String _compactModelUrl =
      'https://huggingface.co/executorch-community/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8-ET/resolve/main/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8.pte';
  static const String _compactTokenizerUrl =
      'https://huggingface.co/executorch-community/Llama-3.2-1B-Instruct-SpinQuant_INT4_EO8-ET/resolve/main/tokenizer.model';

  // RAM threshold: 40% of total RAM should fit model
  static const double _advancedModelSizeGb = 2.66;

  static const String _modelFileName = 'model.pte';
  static const String _tokenizerFileName = 'tokenizer.model';
  static const String _prefsKeyModelDownloaded = 'model_downloaded_v2';

  // Selected model type
  bool _useAdvancedModel = false;
  int _deviceRamBytes = 0;

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
  bool get useAdvancedModel => _useAdvancedModel;
  @Deprecated('Use useAdvancedModel instead')
  bool get useQwenModel => _useAdvancedModel;
  int get deviceRamBytes => _deviceRamBytes;
  String get selectedModelName =>
      _useAdvancedModel ? 'Advanced AI' : 'Compact AI';
  String get selectedModelSize => _useAdvancedModel ? '2.66 GB' : '1.1 GB';

  /// Get the current model and tokenizer URLs based on RAM selection
  String get _modelUrl =>
      _useAdvancedModel ? _advancedModelUrl : _compactModelUrl;
  String get _tokenizerUrl =>
      _useAdvancedModel ? _advancedTokenizerUrl : _compactTokenizerUrl;

  /// Detect device RAM and determine which model to use
  Future<void> _detectRamAndSelectModel() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Android provides system total memory in bytes
        _deviceRamBytes = androidInfo.systemFeatures.isNotEmpty
            ? await _getAndroidRam()
            : 4000000000; // Default 4GB if can't detect
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        // iOS doesn't directly expose RAM, estimate based on device model
        _deviceRamBytes = _estimateIosRam(iosInfo.utsname.machine);
      } else {
        // Desktop platforms - assume sufficient RAM
        _deviceRamBytes = 16000000000; // 16GB default for desktop
      }

      // Check if 40% of RAM can fit the advanced model
      final availableRam = _deviceRamBytes * 0.4;
      final advancedModelBytes = (_advancedModelSizeGb * 1024 * 1024 * 1024)
          .toInt();

      // _useAdvancedModel = availableRam >= advancedModelBytes;
      _useAdvancedModel = false;

      debugPrint('Device RAM: ${getFormattedSize(_deviceRamBytes)}');
      debugPrint('40% of RAM: ${getFormattedSize(availableRam.toInt())}');
      debugPrint(
        'Selected model: ${_useAdvancedModel ? "Advanced AI" : "Compact AI"}',
      );
    } catch (e) {
      debugPrint('Error detecting RAM: $e, defaulting to Compact AI model');
      _useAdvancedModel = false;
    }
  }

  /// Get Android RAM using platform-specific method
  Future<int> _getAndroidRam() async {
    try {
      // Use ProcessInfo to get memory info on Android
      final file = File('/proc/meminfo');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final memTotalLine = contents
            .split('\n')
            .firstWhere(
              (line) => line.startsWith('MemTotal:'),
              orElse: () => '',
            );
        if (memTotalLine.isNotEmpty) {
          // Parse "MemTotal:       16384000 kB"
          final match = RegExp(r'(\d+)').firstMatch(memTotalLine);
          if (match != null) {
            final kbytes = int.parse(match.group(1)!);
            return kbytes * 1024; // Convert KB to bytes
          }
        }
      }
    } catch (e) {
      debugPrint('Error reading /proc/meminfo: $e');
    }
    return 4000000000; // Default 4GB
  }

  /// Estimate iOS RAM based on device model
  int _estimateIosRam(String machine) {
    // Modern iPhones (14 Pro, 15, 16) have 6-8GB RAM
    // Older iPhones have 3-4GB RAM
    if (machine.contains('iPhone15') ||
        machine.contains('iPhone16') ||
        machine.contains('iPhone17')) {
      return 8000000000; // 8GB
    } else if (machine.contains('iPhone14') || machine.contains('iPhone13')) {
      return 6000000000; // 6GB
    } else if (machine.contains('iPad')) {
      return 8000000000; // iPads typically have more RAM
    }
    return 4000000000; // Default 4GB for older devices
  }

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

        // Model should be > 500MB, tokenizer > 100KB (Qwen tokenizer is smaller)
        if (modelSize > 500000000 && tokenizerSize > 100000) {
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

    // Detect RAM and select appropriate model
    await _detectRamAndSelectModel();

    final downloaded = await isModelDownloaded();

    if (downloaded) {
      _status = ModelDownloadStatus.downloaded;
      debugPrint('Model already downloaded: $selectedModelName');
    } else {
      _status = ModelDownloadStatus.notDownloaded;
      debugPrint('Model not downloaded, will use: $selectedModelName');
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

    // Enable wake lock to prevent device from sleeping during download
    try {
      await WakelockPlus.enable();
      debugPrint('Wake lock enabled');
    } catch (e) {
      debugPrint('Failed to enable wake lock: $e');
    }

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

      // Download model (large file)
      final sizeMsg = 'Downloading $selectedModelName ($selectedModelSize)...';
      onProgress?.call(0.03, sizeMsg);
      _updateProgress(0.03, sizeMsg);

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
    } finally {
      // Always disable wake lock when done
      try {
        await WakelockPlus.disable();
        debugPrint('Wake lock disabled');
      } catch (e) {
        debugPrint('Failed to disable wake lock: $e');
      }
    }
  }

  /// Download a file with progress tracking using dio (with retry support)
  Future<bool> _downloadFile(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
    int maxRetries = 3,
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      attempt++;
      debugPrint('Download attempt $attempt of $maxRetries');

      try {
        debugPrint('Downloading: $url');
        debugPrint('Saving to: $savePath');

        final dio = Dio();

        // Configure for better download performance
        dio.options.connectTimeout = const Duration(seconds: 60);
        dio.options.receiveTimeout = const Duration(minutes: 60);
        dio.options.followRedirects = true;
        dio.options.maxRedirects = 5;

        // First get the file size
        int contentLength = 0;
        try {
          final headResponse = await dio.head(
            url,
            options: Options(followRedirects: true, maxRedirects: 5),
          );
          contentLength =
              int.tryParse(
                headResponse.headers.value('content-length') ?? '0',
              ) ??
              0;
          debugPrint('Content length: $contentLength bytes');
        } catch (e) {
          debugPrint('HEAD request failed, will try download anyway: $e');
        }

        // Use simple download for all files (chunked downloads don't work well with HF's signed URLs)
        debugPrint('Starting download...');
        await dio.download(
          url,
          savePath,
          options: Options(
            followRedirects: true,
            maxRedirects: 5,
            receiveTimeout: const Duration(
              minutes: 60,
            ), // Longer timeout for large files
          ),
          onReceiveProgress: (received, total) {
            final effectiveTotal = total > 0
                ? total
                : (contentLength > 0 ? contentLength : received);
            onProgress?.call(received, effectiveTotal);
          },
        );

        final fileSize = await File(savePath).length();
        debugPrint('Downloaded $fileSize bytes to $savePath');

        return true;
      } on DioException catch (e) {
        debugPrint(
          'Dio download error (attempt $attempt): ${e.type} - ${e.message}',
        );
        debugPrint(
          'Response: ${e.response?.statusCode} ${e.response?.statusMessage}',
        );
        debugPrint('Error details: ${e.error}');

        // Retry on connection/timeout errors
        if (attempt < maxRetries &&
            (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionError ||
                e.type == DioExceptionType.unknown)) {
          debugPrint('Retrying in 3 seconds...');
          await Future.delayed(const Duration(seconds: 3));
          continue;
        }
        return false;
      } catch (e, stackTrace) {
        debugPrint('Download error (attempt $attempt): $e');
        debugPrint('Stack trace: $stackTrace');

        if (attempt < maxRetries) {
          debugPrint('Retrying in 3 seconds...');
          await Future.delayed(const Duration(seconds: 3));
          continue;
        }
        return false;
      }
    }

    return false; // All retries exhausted
  }

  void _updateProgress(double progress, String message) {
    _downloadProgress = progress;
    // debugPrint(
    //   'Download progress: ${(progress * 100).toStringAsFixed(1)}% - $message',
    // );
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
