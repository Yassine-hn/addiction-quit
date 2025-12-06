// user_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import 'user_repository_abstract.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get the current active user (first active user in database)
  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final db = await _dbHelper.database;
      final users = await UsersTable.getAll(db);
      
      // Get first active user or first user if no active filter
      final activeUser = users.firstWhere(
        (user) => (user['is_active'] as int? ?? 1) == 1,
        orElse: () => users.isNotEmpty ? users.first : <String, dynamic>{},
      );
      
      return activeUser.isNotEmpty ? activeUser : null;
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
    final user = await getCurrentUser();
    return user?['id'] as int?;
  }
}

