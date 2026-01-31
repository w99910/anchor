import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AI Provider options
enum AiProvider {
  onDevice, // On-device AI model
  cloud, // Cloud provider (Gemini)
}

/// Service to manage AI provider settings
class AiSettingsService extends ChangeNotifier {
  static final AiSettingsService _instance = AiSettingsService._internal();
  factory AiSettingsService() => _instance;
  AiSettingsService._internal();

  static const String _prefsKeyAiProvider = 'ai_provider';

  AiProvider _aiProvider = AiProvider.onDevice;
  bool _initialized = false;

  /// Current AI provider
  AiProvider get aiProvider => _aiProvider;

  /// Whether using cloud provider
  bool get isCloudProvider => _aiProvider == AiProvider.cloud;

  /// Whether using on-device provider
  bool get isOnDeviceProvider => _aiProvider == AiProvider.onDevice;

  /// Initialize the service
  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final providerIndex = prefs.getInt(_prefsKeyAiProvider) ?? 0;
    _aiProvider = AiProvider.values[providerIndex];
    _initialized = true;
    notifyListeners();
  }

  /// Set AI provider
  Future<void> setAiProvider(AiProvider provider) async {
    if (_aiProvider == provider) return;

    _aiProvider = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyAiProvider, provider.index);
    notifyListeners();

    debugPrint('AI provider set to: ${provider.name}');
  }

  /// Toggle between on-device and cloud
  Future<void> toggleProvider() async {
    final newProvider = _aiProvider == AiProvider.onDevice
        ? AiProvider.cloud
        : AiProvider.onDevice;
    await setAiProvider(newProvider);
  }
}
