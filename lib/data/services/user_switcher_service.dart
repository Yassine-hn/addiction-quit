// file: lib/data/services/user_switcher_service.dart
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import '../storage/token_storage.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

class UserSwitcherService {
  /// Fetch all users from the database
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DatabaseHelper.instance.database;
    return await UsersTable.getAll(db);
  }

  /// Switch to a different user
  /// - Updates SharedPreferences with new user ID
  /// - Clears all tokens (logout)
  /// - Returns true if successful
  static Future<bool> switchUser(String userId) async {
    try {
      // Update SharedPreferences
      await SharedPreferencesHelper.saveUserId(userId);
      
      // Clear tokens and auth data (logout)
      await TokenStorage.clearAll();
      
      print('Switched to user: $userId');
      return true;
    } catch (e) {
      print('Error switching user: $e');
      return false;
    }
  }

  /// Get current user ID from SharedPreferences
  static Future<String?> getCurrentUserId() async {
    return await SharedPreferencesHelper.getUserId();
  }

  /// Check if a user exists in database
  static Future<bool> userExists(String userId) async {
    final db = await DatabaseHelper.instance.database;
    final user = await UsersTable.getById(db, userId);
    return user != null;
  }
}
