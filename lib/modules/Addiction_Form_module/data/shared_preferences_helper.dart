// file: lib/modules/Addiction_Form_module/data/shared_preferences_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _addictionIdKey = 'current_addiction_id';
  static const String _addictionIdsKey =
      'addiction_ids'; // List of all addiction IDs
  static const String _languageKey = 'language'; // en or ar

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

  /// Save addiction ID to the list of addiction IDs
  static Future<bool> addAddictionId(int addictionId) async {
    final prefs = await SharedPreferences.getInstance();
    final existingIds = await getAllAddictionIds();
    if (!existingIds.contains(addictionId)) {
      existingIds.add(addictionId);
      final idsString = existingIds.join(',');
      return await prefs.setString(_addictionIdsKey, idsString);
    }
    return true;
  }

  /// Get all addiction IDs for the user (async version)
  static Future<List<int>> getAllAddictionIds() async {
    final prefs = await SharedPreferences.getInstance();
    final idsString = prefs.getString(_addictionIdsKey);
    if (idsString == null || idsString.isEmpty) {
      return [];
    }
    try {
      return idsString.split(',').map((id) => int.parse(id)).toList();
    } catch (e) {
      print('Error parsing addiction IDs: $e');
      return [];
    }
  }

  /// Set all addiction IDs at once
  static Future<bool> setAllAddictionIds(List<int> addictionIds) async {
    final prefs = await SharedPreferences.getInstance();
    final idsString = addictionIds.join(',');
    return await prefs.setString(_addictionIdsKey, idsString);
  }

  /// Get all user preferences
  static Future<Map<String, dynamic>> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt(_userIdKey),
      'username': prefs.getString(_usernameKey),
      'is_first_time': prefs.getBool(_isFirstTimeKey) ?? true,
      'current_addiction_id': prefs.getInt(_addictionIdKey),
      'addiction_ids': await getAllAddictionIds(),
    };
  }

  /// Save language preference
  static Future<bool> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_languageKey, languageCode);
  }

  /// Get saved language preference (default: 'en')
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
}
