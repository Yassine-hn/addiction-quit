// file: lib/modules/Addiction_Form_module/data/user_data_service.dart
import '../../../data/databases/db_helper.dart';
import '../../../data/databases/tables/addictions_table.dart';
import '../../../data/databases/tables/users_table.dart';
import '../models/User_Info_model.dart';
import 'shared_preferences_helper.dart'; // Add this import

class UserDataService {
  /// Get existing user ID or create a new user
  static Future<int> getOrCreateUserId(String username) async {
    // Check if user ID exists in SharedPreferences
    final existingUserId = await SharedPreferencesHelper.getUserId();

    if (existingUserId != null) {
      // Verify user exists in database
      final db = await DatabaseHelper.instance.database;
      final user = await UsersTable.getById(db, existingUserId);

      if (user != null) {
        print('Existing user found: ID $existingUserId, Name: ${user['name']}');
        return existingUserId;
      } else {
        // User exists in SharedPreferences but not in database (corrupted state)
        print(
          'User ID found in SharedPreferences but not in database. Creating new user...',
        );
        // Clear the invalid ID
        await SharedPreferencesHelper.clearUserData();
      }
    }

    // Create new user in database (this generates a UNIQUE auto-increment ID)
    final db = await DatabaseHelper.instance.database;
    final newUser = {
      'name': username,
      'created_at': DateTime.now().toIso8601String(),
      // Other fields can remain null
    };

    final newUserId = await UsersTable.insert(db, newUser);
    print('Created new user with ID: $newUserId');

    // Save the new user ID to SharedPreferences
    await SharedPreferencesHelper.saveUserId(newUserId);
    await SharedPreferencesHelper.saveUsername(username);
    await SharedPreferencesHelper.markAsNotFirstTime();

    return newUserId;
  }

  /// Create addiction from UserInfoModel
  static Future<int> createAddiction(int userId, UserInfoModel userInfo) async {
    final db = await DatabaseHelper.instance.database;

    // Check if addiction type already exists for this user
    final existingAddictions = await AddictionsTable.getByUserId(db, userId);
    final addictionType = userInfo.addictionType ?? 'unknown';
    
    final duplicateExists = existingAddictions.any(
      (addiction) => 
          (addiction['type'] as String? ?? '').toLowerCase() == 
          addictionType.toLowerCase() &&
          (addiction['status'] as String? ?? 'active') == 'active',
    );
    
    if (duplicateExists) {
      throw Exception('An active addiction of type "$addictionType" already exists. Please choose a different type or deactivate the existing one.');
    }

    // Extract money saved per day (with validation)
    double? moneySavedPerDay;
    if (userInfo.moneySavedPerDay != null &&
        userInfo.moneySavedPerDay!['amount'] != null) {
      try {
        moneySavedPerDay = (userInfo.moneySavedPerDay!['amount'] as num)
            .toDouble();
      } catch (e) {
        print('Error converting money saved: $e');
        moneySavedPerDay = 0.0;
      }
    }

    // Convert UserInfoModel to addiction data
    final addictionData = {
      'user_id': userId,
      'type': userInfo.addictionType ?? 'unknown',
      'start_date':
          userInfo.startDate?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'counter_start_at': DateTime.now().toIso8601String(),
      'slips': 0,
      'goal_type': _getGoalType(userInfo.goals),
      'daily_target': userInfo.consumptionPerDay ?? 0,
      'streak': 0,
      'status': 'active',
      'note': _buildAddictionNote(userInfo),
      'motivation': userInfo.mainMotivation,
      'time_saved_per_day': _calculateTimeSavedPerDay(userInfo),
      'money_saved_per_day': moneySavedPerDay ?? 0.0,
      'created_at': DateTime.now().toIso8601String(),
    };

    print('Creating addiction with data: $addictionData');
    final addictionId = await AddictionsTable.insert(db, addictionData);
    print('Addiction created with ID: $addictionId');

    // Save the addiction ID to SharedPreferences for quick access
    await SharedPreferencesHelper.saveAddictionId(addictionId);

    // Add to the list of all addiction IDs
    await SharedPreferencesHelper.addAddictionId(addictionId);

    return addictionId;
  }

  /// Helper to calculate time saved per day (in minutes)
  static int _calculateTimeSavedPerDay(UserInfoModel userInfo) {
    // Default: assume 30 minutes per consumption day
    final daysPerWeek = userInfo.consumptionDayPerWeek ?? 0;
    final consumptionPerDay = userInfo.consumptionPerDay ?? 0;

    if (consumptionPerDay == 0) return 0;

    // Estimate: each consumption takes ~30 minutes
    return (daysPerWeek * consumptionPerDay * 30) ~/ 7;
  }

  /// Helper to determine goal type
  static String _getGoalType(List<String>? goals) {
    if (goals == null || goals.isEmpty) return 'quit';

    // Check for common goal types
    final firstGoal = goals.first.toLowerCase();
    if (firstGoal.contains('reduce')) return 'reduce';
    if (firstGoal.contains('quit')) return 'quit';
    if (firstGoal.contains('control')) return 'control';
    if (firstGoal.contains('limit')) return 'limit';
    return 'other';
  }

  /// Build a note from user info
  static String _buildAddictionNote(UserInfoModel userInfo) {
    final noteParts = <String>[];

    if (userInfo.consumptionDayPerWeek != null) {
      noteParts.add('Days per week: ${userInfo.consumptionDayPerWeek}');
    }

    if (userInfo.consumptionPerDay != null) {
      noteParts.add('Per day: ${userInfo.consumptionPerDay}');
    }

    if (userInfo.goals != null && userInfo.goals!.isNotEmpty) {
      noteParts.add('Goals: ${userInfo.goals!.join(", ")}');
    }

    if (userInfo.importanceForUser != null) {
      noteParts.add('Importance: ${userInfo.importanceForUser}');
    }

    if (userInfo.impliedPeople != null) {
      noteParts.add('Affected people: ${userInfo.impliedPeople}');
    }

    return noteParts.join(' | ');
  }

  /// Check if user exists
  static Future<bool> userExists() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) return false;

    final db = await DatabaseHelper.instance.database;
    final user = await UsersTable.getById(db, userId);
    return user != null;
  }

  /// Get existing user ID (returns null if not exists)
  static Future<int?> getExistingUserId() async {
    return await SharedPreferencesHelper.getUserId();
  }

  /// Get current user info
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) return null;

    final db = await DatabaseHelper.instance.database;
    return await UsersTable.getById(db, userId);
  }

  /// Update user profile
  static Future<int> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) throw Exception('No user logged in');

    final db = await DatabaseHelper.instance.database;
    return await UsersTable.update(db, userId, updates);
  }
}
