import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving user profile information
class UserInfoService extends ChangeNotifier {
  static final UserInfoService _instance = UserInfoService._internal();
  factory UserInfoService() => _instance;
  UserInfoService._internal();

  // SharedPreferences keys
  static const String _keyUserName = 'user_name';
  static const String _keyUserGender = 'user_gender';
  static const String _keyUserBirthYear = 'user_birth_year';

  // Cached values
  String? _userName;
  String? _userGender;
  int? _userBirthYear;
  bool _isLoaded = false;

  // Getters
  String? get userName => _userName;
  String? get userGender => _userGender;
  int? get userBirthYear => _userBirthYear;
  bool get isLoaded => _isLoaded;

  /// Check if user info has been set
  bool get hasUserInfo => _userName != null && _userName!.isNotEmpty;

  /// Get user's age based on birth year
  int? get userAge {
    if (_userBirthYear == null) return null;
    return DateTime.now().year - _userBirthYear!;
  }

  /// Load user info from SharedPreferences
  Future<void> load() async {
    if (_isLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString(_keyUserName);
      _userGender = prefs.getString(_keyUserGender);
      _userBirthYear = prefs.getInt(_keyUserBirthYear);
      _isLoaded = true;
      debugPrint(
        'UserInfoService loaded: name=$_userName, gender=$_userGender, birthYear=$_userBirthYear',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user info: $e');
    }
  }

  /// Save user info to SharedPreferences
  Future<void> saveUserInfo({
    required String name,
    required String gender,
    required int birthYear,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserName, name);
      await prefs.setString(_keyUserGender, gender);
      await prefs.setInt(_keyUserBirthYear, birthYear);

      _userName = name;
      _userGender = gender;
      _userBirthYear = birthYear;
      _isLoaded = true;

      debugPrint(
        'UserInfoService saved: name=$name, gender=$gender, birthYear=$birthYear',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user info: $e');
    }
  }

  /// Update user name only
  Future<void> updateUserName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserName, name);
      _userName = name;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user name: $e');
    }
  }

  /// Get user context string for AI prompts
  /// Returns a formatted string with user information for personalization
  String getUserContext() {
    if (!hasUserInfo) return '';

    final parts = <String>[];

    if (_userName != null && _userName!.isNotEmpty) {
      parts.add("The user's name is $_userName.");
    }

    if (userAge != null) {
      parts.add("They are $userAge years old.");
    }

    if (_userGender != null && _userGender != 'preferNotToSay') {
      String genderText;
      switch (_userGender) {
        case 'male':
          genderText = 'male';
          break;
        case 'female':
          genderText = 'female';
          break;
        case 'nonBinary':
          genderText = 'non-binary';
          break;
        default:
          genderText = '';
      }
      if (genderText.isNotEmpty) {
        parts.add("They identify as $genderText.");
      }
    }

    if (parts.isEmpty) return '';

    return '\n\nUser Context: ${parts.join(' ')} Use their name occasionally to make the conversation feel personal, but don\'t overuse it.';
  }

  /// Clear all user info
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserName);
      await prefs.remove(_keyUserGender);
      await prefs.remove(_keyUserBirthYear);

      _userName = null;
      _userGender = null;
      _userBirthYear = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing user info: $e');
    }
  }
}
