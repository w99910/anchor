import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage app locale preferences
class LocaleService extends ChangeNotifier {
  static const String _prefsKeyLocale = 'app_locale';

  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  Locale _locale = const Locale('en');
  bool _initialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _initialized;

  /// All supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('th'), // Thai
    Locale('de'), // German
    Locale('fr'), // French
    Locale('it'), // Italian
    Locale('pt'), // Portuguese
    Locale('hi'), // Hindi
    Locale('es'), // Spanish
  ];

  /// Get display name for a locale
  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'th':
        return 'ไทย';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'hi':
        return 'हिन्दी';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }

  /// Get native name for a locale (same as display name for now)
  static String getNativeName(Locale locale) => getDisplayName(locale);

  /// Get English name for a locale
  static String getEnglishName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'th':
        return 'Thai';
      case 'de':
        return 'German';
      case 'fr':
        return 'French';
      case 'it':
        return 'Italian';
      case 'pt':
        return 'Portuguese';
      case 'hi':
        return 'Hindi';
      case 'es':
        return 'Spanish';
      default:
        return locale.languageCode;
    }
  }

  /// Initialize the service and load saved locale
  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_prefsKeyLocale);

    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }

    _initialized = true;
    notifyListeners();
  }

  /// Set and persist locale
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyLocale, locale.languageCode);

    _locale = locale;
    notifyListeners();
  }

  /// Check if a locale preference has been set
  Future<bool> hasLocalePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_prefsKeyLocale);
  }
}

// Global locale notifier for the app
final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

// Global locale service instance
final localeService = LocaleService();
