// file: lib/modules/Addiction_Form_module/data/shared_preferences_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _addictionIdKey = 'current_addiction_id';

  /// Get the saved user ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Save user ID
  static Future<bool> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_userIdKey, userId);
  }

  /// Save username
  static Future<bool> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_usernameKey, username);
  }

  /// Get saved username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Check if it's first time (no user ID exists)
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_userIdKey);
  }

  /// Mark as not first time
  static Future<bool> markAsNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_isFirstTimeKey, false);
  }

  /// Save current addiction ID
  static Future<bool> saveAddictionId(int addictionId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_addictionIdKey, addictionId);
  }

  /// Get current addiction ID
  static Future<int?> getAddictionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_addictionIdKey);
  }

  /// Clear all user data (logout)
  static Future<bool> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  /// Get all user preferences
  static Future<Map<String, dynamic>> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt(_userIdKey),
      'username': prefs.getString(_usernameKey),
      'is_first_time': prefs.getBool(_isFirstTimeKey) ?? true,
      'current_addiction_id': prefs.getInt(_addictionIdKey),
    };
  }
}
