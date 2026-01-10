// Create new file: shared_preferences_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _currentAddictionIdKey = 'current_addiction_id';
  static const String _userIdKey = 'user_id';
  static const String _firstLaunchKey = 'first_launch';
  static const String _addictionListOrderKey = 'addiction_list_order';

  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get current addiction ID
  static int? getCurrentAddictionId() {
    return _prefs.getInt(_currentAddictionIdKey);
  }

  /// Set current addiction ID
  static Future<void> setCurrentAddictionId(int addictionId) async {
    await _prefs.setInt(_currentAddictionIdKey, addictionId);
  }

  /// Get user ID
  static String? getUserId() {
    // Prefer the string value; fall back to legacy int and migrate to string
    final stored = _prefs.getString(_userIdKey);
    if (stored != null) return stored;

    final legacyInt = _prefs.getInt(_userIdKey);
    if (legacyInt != null) {
      final migrated = legacyInt.toString();
      _prefs.setString(_userIdKey, migrated);
      return migrated;
    }

    return null;
  }

  /// Set user ID
  static Future<void> setUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Check if first launch
  static bool isFirstLaunch() {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Mark app as launched
  static Future<void> markAsLaunched() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  /// Save addiction list order
  static Future<void> saveAddictionOrder(List<int> addictionIds) async {
    final orderString = addictionIds.join(',');
    await _prefs.setString(_addictionListOrderKey, orderString);
  }

  /// Get addiction list order
  static List<int> getAddictionOrder() {
    final orderString = _prefs.getString(_addictionListOrderKey);
    if (orderString == null || orderString.isEmpty) {
      return [];
    }
    return orderString.split(',').map(int.parse).toList();
  }

  /// Clear all preferences (for testing)
  static Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Clear only addiction-related preferences
  static Future<void> clearAddictionData() async {
    await _prefs.remove(_currentAddictionIdKey);
    await _prefs.remove(_addictionListOrderKey);
  }

  /// Debug print all preferences
  static void debugPrint() {
    print('📱 SharedPreferences:');
    print('  Current Addiction ID: ${getCurrentAddictionId()}');
    print('  User ID: ${getUserId()}');
    print('  First Launch: ${isFirstLaunch()}');
    print('  Addiction Order: ${getAddictionOrder()}');
  }
}
