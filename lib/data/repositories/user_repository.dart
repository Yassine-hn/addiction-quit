// user_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import 'user_repository_abstract.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get the current active user (using user_id from SharedPreferences)
  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // Get user ID from SharedPreferences
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        return null;
      }

      final db = await _dbHelper.database;
      return await UsersTable.getById(db, userId);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Get user name for greeting
  @override
  Future<String?> getUserName() async {
    final user = await getCurrentUser();
    return user?['name'] as String?;
  }

  /// Get current user ID
  @override
  Future<int?> getCurrentUserId() async {
    // Get directly from SharedPreferences for consistency
    return await SharedPreferencesHelper.getUserId();
  }
}
