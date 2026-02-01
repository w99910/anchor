import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Lock Service
///
/// Manages app lock functionality including:
/// - PIN code storage and verification
/// - Biometric authentication
/// - Lock state management
class AppLockService extends ChangeNotifier {
  static final AppLockService _instance = AppLockService._internal();
  factory AppLockService() => _instance;
  AppLockService._internal();

  // Storage keys
  static const String _keyAppLockEnabled = 'app_lock_enabled';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLockOnBackground = 'lock_on_background';
  static const String _keyPinCode = 'app_lock_pin';
  static const String _keyFailedAttempts = 'failed_attempts';
  static const String _keyLockoutUntil = 'lockout_until';

  // Services
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  final LocalAuthentication _localAuth = LocalAuthentication();

  // State
  bool _initialized = false;
  bool _isLockEnabled = false;
  bool _isBiometricEnabled = false;
  bool _lockOnBackground = true;
  bool _isLocked = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  // Configuration
  static const int maxFailedAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 1);

  // Getters
  bool get isInitialized => _initialized;
  bool get isLockEnabled => _isLockEnabled;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get lockOnBackground => _lockOnBackground;
  bool get isLocked => _isLocked;
  bool get canUseBiometrics =>
      _canCheckBiometrics && _availableBiometrics.isNotEmpty;
  List<BiometricType> get availableBiometrics => _availableBiometrics;
  int get failedAttempts => _failedAttempts;
  bool get isLockedOut =>
      _lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!);
  Duration get remainingLockoutTime => _lockoutUntil != null
      ? _lockoutUntil!.difference(DateTime.now())
      : Duration.zero;

  /// Initialize the service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load preferences
      _isLockEnabled = prefs.getBool(_keyAppLockEnabled) ?? false;
      _isBiometricEnabled = prefs.getBool(_keyBiometricEnabled) ?? false;
      _lockOnBackground = prefs.getBool(_keyLockOnBackground) ?? true;
      _failedAttempts = prefs.getInt(_keyFailedAttempts) ?? 0;

      final lockoutUntilMs = prefs.getInt(_keyLockoutUntil);
      if (lockoutUntilMs != null) {
        _lockoutUntil = DateTime.fromMillisecondsSinceEpoch(lockoutUntilMs);
        if (DateTime.now().isAfter(_lockoutUntil!)) {
          _lockoutUntil = null;
          _failedAttempts = 0;
          await prefs.remove(_keyLockoutUntil);
          await prefs.setInt(_keyFailedAttempts, 0);
        }
      }

      // Check biometric capabilities
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (_canCheckBiometrics) {
        _availableBiometrics = await _localAuth.getAvailableBiometrics();
      }

      // Set initial lock state
      _isLocked = _isLockEnabled;

      _initialized = true;
      notifyListeners();

      if (kDebugMode) {
        print('AppLockService: Initialized');
        print('AppLockService: Lock enabled = $_isLockEnabled');
        print('AppLockService: Biometrics available = $canUseBiometrics');
        print('AppLockService: Available biometrics = $_availableBiometrics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AppLockService: Initialize error: $e');
      }
    }
  }

  /// Check if a PIN has been set
  Future<bool> hasPinSet() async {
    final pin = await _secureStorage.read(key: _keyPinCode);
    return pin != null && pin.isNotEmpty;
  }

  /// Set up a new PIN
  Future<bool> setPin(String pin) async {
    if (pin.length != 4) {
      return false;
    }

    try {
      await _secureStorage.write(key: _keyPinCode, value: pin);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAppLockEnabled, true);
      _isLockEnabled = true;
      _isLocked = false; // Unlock after setting PIN

      // Reset failed attempts
      _failedAttempts = 0;
      await prefs.setInt(_keyFailedAttempts, 0);

      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AppLockService: Set PIN error: $e');
      }
      return false;
    }
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    if (isLockedOut) {
      return false;
    }

    try {
      final storedPin = await _secureStorage.read(key: _keyPinCode);
      final isValid = storedPin == pin;

      if (isValid) {
        _failedAttempts = 0;
        _lockoutUntil = null;
        _isLocked = false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyFailedAttempts, 0);
        await prefs.remove(_keyLockoutUntil);

        notifyListeners();
      } else {
        await _recordFailedAttempt();
      }

      return isValid;
    } catch (e) {
      if (kDebugMode) {
        print('AppLockService: Verify PIN error: $e');
      }
      return false;
    }
  }

  /// Record a failed attempt
  Future<void> _recordFailedAttempt() async {
    _failedAttempts++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFailedAttempts, _failedAttempts);

    if (_failedAttempts >= maxFailedAttempts) {
      _lockoutUntil = DateTime.now().add(lockoutDuration);
      await prefs.setInt(
        _keyLockoutUntil,
        _lockoutUntil!.millisecondsSinceEpoch,
      );
    }

    notifyListeners();
  }

  /// Change PIN
  Future<bool> changePin(String oldPin, String newPin) async {
    final isValid = await verifyPin(oldPin);
    if (!isValid) return false;

    return setPin(newPin);
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({String? reason}) async {
    if (!canUseBiometrics || !_isBiometricEnabled) {
      return false;
    }

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason ?? 'Unlock Anchor',
        authMessages: const [],
      );

      if (didAuthenticate) {
        _isLocked = false;
        _failedAttempts = 0;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyFailedAttempts, 0);
        await prefs.remove(_keyLockoutUntil);

        notifyListeners();
      }

      return didAuthenticate;
    } catch (e) {
      if (kDebugMode) {
        print('AppLockService: Biometric auth error: $e');
      }
      return false;
    }
  }

  /// Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    if (!canUseBiometrics && enabled) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
    _isBiometricEnabled = enabled;
    notifyListeners();
  }

  /// Enable/disable lock on background
  Future<void> setLockOnBackground(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLockOnBackground, enabled);
    _lockOnBackground = enabled;
    notifyListeners();
  }

  /// Lock the app
  void lock() {
    if (_isLockEnabled) {
      _isLocked = true;
      notifyListeners();
    }
  }

  /// Unlock the app (called after successful authentication)
  void unlock() {
    _isLocked = false;
    _failedAttempts = 0;
    notifyListeners();
  }

  /// Disable app lock completely
  Future<void> disableLock(String pin) async {
    final isValid = await verifyPin(pin);
    if (!isValid) return;

    try {
      await _secureStorage.delete(key: _keyPinCode);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAppLockEnabled, false);
      await prefs.setBool(_keyBiometricEnabled, false);
      await prefs.remove(_keyFailedAttempts);
      await prefs.remove(_keyLockoutUntil);

      _isLockEnabled = false;
      _isBiometricEnabled = false;
      _isLocked = false;
      _failedAttempts = 0;
      _lockoutUntil = null;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('AppLockService: Disable lock error: $e');
      }
    }
  }

  /// Get biometric type name for display
  String getBiometricTypeName() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    return 'Biometric';
  }
}

// Global instance
final appLockService = AppLockService();
