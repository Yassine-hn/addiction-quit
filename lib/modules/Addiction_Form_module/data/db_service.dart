// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import '../../../data/databases/db_helper.dart';
import '../../../data/databases/tables/addictions_table.dart';
import '../../../data/databases/tables/activity_logs_table.dart';
import '../models/User_Info_model.dart';
import './shared_preference_manager.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Save user information to database (for new user OR new addiction)
  Future<Map<String, int>> saveUserInfo(UserInfoModel userInfo) async {
    final db = await _dbHelper.database;

    try {
      await db.execute('BEGIN TRANSACTION');

      // Check if user already exists
      int userId;
      final existingUserId = SharedPreferencesManager.getUserId();

      if (existingUserId != null) {
        // Existing user - update their info
        userId = existingUserId;
        await _updateUser(db, userId, userInfo);
      } else {
        // New user - create
        userId = await _saveUser(db, userInfo);
        await SharedPreferencesManager.setUserId(userId);
      }

      // Create new addiction
      final addictionId = await _saveAddiction(db, userInfo, userId);

      // Set as current addiction
      await SharedPreferencesManager.setCurrentAddictionId(addictionId);

      // Update addiction order
      await _updateAddictionOrder(db, userId, addictionId);

      // Create initial milestones, reminders, etc.
      await _createInitialMilestones(db, userInfo, addictionId, userId);
      await _createReminders(db, userInfo, userId, addictionId);
      await _logInitialActivity(db, userId, userInfo);

      await db.execute('COMMIT');

      print('✅ Addiction saved successfully!');
      print('   User ID: $userId');
      print('   Addiction ID: $addictionId');

      return {'userId': userId, 'addictionId': addictionId};
    } catch (e) {
      await db.execute('ROLLBACK');
      print('❌ Error saving user info: $e');
      rethrow;
    }
  }

  /// Save user to users table
  Future<int> _saveUser(Database db, UserInfoModel userInfo) async {
    return await db.insert('users', {
      'name': userInfo.username,
      'created_at': DateTime.now().toIso8601String(),
      'score': 0,
      'is_active': 1,
    });
  }

  /// Update existing user
  Future<void> _updateUser(
    Database db,
    int userId,
    UserInfoModel userInfo,
  ) async {
    await db.update(
      'users',
      {
        'name': userInfo.username,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Save addiction to addictions table
  Future<int> _saveAddiction(
    Database db,
    UserInfoModel userInfo,
    int userId,
  ) async {
    // Calculate consumption per week
    final consumptionPerWeek =
        (userInfo.consumptionDayPerWeek ?? 0) *
        (userInfo.consumptionPerDay ?? 0);

    return await db.insert('addictions', {
      'user_id': userId,
      'type': userInfo.addictionType,
      'start_date': userInfo.startDate?.toIso8601String(),
      'counter_start_at': userInfo.startDate?.toIso8601String(),
      'slips': 0,
      'goal_type': _getGoalType(userInfo),
      'daily_target': _calculateDailyTarget(userInfo),
      'streak': 0,
      'status': 'active',
      'note':
          'Motivation: ${userInfo.mainMotivation}\nImportance: ${userInfo.importanceForUser}',
      'motivation': userInfo.mainMotivation,
      'created_at': DateTime.now().toIso8601String(),
      'position': 0, // New addictions go to top
    });
  }

  /// Helper method to determine goal type
  String _getGoalType(UserInfoModel userInfo) {
    if (userInfo.goals?.contains('Quit completely') == true) return 'quit';
    if (userInfo.goals?.contains('Reduce consumption') == true) return 'reduce';
    return 'control';
  }

  /// Helper method to calculate daily target
  int? _calculateDailyTarget(UserInfoModel userInfo) {
    if (userInfo.goals?.contains('Quit completely') == true) return 0;
    if (userInfo.consumptionPerDay != null) {
      // Example: Reduce by 50% initially
      return (userInfo.consumptionPerDay! * 0.5).ceil();
    }
    return null;
  }

  /// Update addiction order
  Future<void> _updateAddictionOrder(
    Database db,
    int userId,
    int newAddictionId,
  ) async {
    // Get existing addictions for this user
    final addictions = await AddictionsTable.getByUserId(db, userId);

    // Update positions (shift existing ones down)
    for (int i = 0; i < addictions.length; i++) {
      final addiction = addictions[i];
      if (addiction['id'] == newAddictionId) {
        continue; // Skip the new one
      }
      await db.update(
        'addictions',
        {'position': i + 1}, // Shift existing ones down
        where: 'id = ?',
        whereArgs: [addiction['id']],
      );
    }

    // Save order to SharedPreferences
    final orderedAddictions =
        [newAddictionId] +
        addictions
            .where((a) => a['id'] != newAddictionId)
            .map((a) => a['id'] as int)
            .toList();
    await SharedPreferencesManager.saveAddictionOrder(orderedAddictions);
  }

  /// Create initial milestones
  Future<void> _createInitialMilestones(
    Database db,
    UserInfoModel userInfo,
    int addictionId,
    int userId,
  ) async {
    final milestones = <Map<String, dynamic>>[];

    // 24-hour milestone
    milestones.add({
      'addiction_id': addictionId,
      'title': 'First 24 Hours',
      'description': 'Stay clean for your first day',
      'target_value': 1,
      'type': 'time_based',
      'reward_points': 10,
      'created_at': DateTime.now().toIso8601String(),
    });

    // 1-week milestone
    milestones.add({
      'addiction_id': addictionId,
      'title': 'One Week Clean',
      'description':
          'Complete your first week without ${userInfo.addictionType?.toLowerCase() ?? "the addiction"}',
      'target_value': 7,
      'type': 'time_based',
      'reward_points': 50,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Money saved milestone
    if (userInfo.moneySavedPerDay != null) {
      final amount = userInfo.moneySavedPerDay!['amount'] as num;
      final currency = userInfo.moneySavedPerDay!['currency'] as String;

      milestones.add({
        'addiction_id': addictionId,
        'title': 'Save Your First $currency${amount * 7}',
        'description': 'Save one week\'s worth of money',
        'target_value': 7,
        'type': 'money_saved',
        'reward_points': 25,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Insert all milestones
    for (final milestone in milestones) {
      await db.insert('milestones', milestone);
    }
  }

  /// Create reminders
  Future<void> _createReminders(
    Database db,
    UserInfoModel userInfo,
    int userId,
    int addictionId,
  ) async {
    if (userInfo.dailyReview != null) {
      final reminderTime = userInfo.dailyReview!;
      final timeString =
          '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';

      await db.insert('reminders', {
        'user_id': userId,
        'addiction_id': addictionId,
        'reminder_time': timeString,
        'repeat_daily': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Log initial activity
  Future<void> _logInitialActivity(
    Database db,
    int userId,
    UserInfoModel userInfo,
  ) async {
    await db.insert('activity_logs', {
      'user_id': userId,
      'action_type': 'addiction_created',
      'meta':
          'Addiction type: ${userInfo.addictionType}, Goals: ${userInfo.goals?.join(", ")}',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get all addictions for current user
  Future<List<Map<String, dynamic>>> getAddictionsForCurrentUser() async {
    final userId = SharedPreferencesManager.getUserId();
    if (userId == null) return [];

    final db = await _dbHelper.database;
    final addictions = await AddictionsTable.getByUserId(db, userId);

    // Sort by position
    addictions.sort((a, b) {
      final posA = a['position'] as int? ?? 0;
      final posB = b['position'] as int? ?? 0;
      return posA.compareTo(posB);
    });

    return addictions;
  }

  /// Get current addiction details
  Future<Map<String, dynamic>?> getCurrentAddiction() async {
    final currentId = SharedPreferencesManager.getCurrentAddictionId();
    if (currentId == null) return null;

    final db = await _dbHelper.database;
    return await AddictionsTable.getById(db, currentId);
  }

  /// Switch to a different addiction
  Future<void> switchAddiction(int addictionId) async {
    await SharedPreferencesManager.setCurrentAddictionId(addictionId);

    // Log the switch
    final db = await _dbHelper.database;
    final userId = SharedPreferencesManager.getUserId();
    if (userId != null) {
      await ActivityLogsTable.logAction(
        db,
        userId,
        'addiction_switched',
        'Switched to addiction ID: $addictionId',
      );
    }
  }

  /// Delete an addiction
  Future<void> deleteAddiction(int addictionId) async {
    final db = await _dbHelper.database;

    // Start transaction
    await db.execute('BEGIN TRANSACTION');

    try {
      // Delete related records first (due to foreign keys)
      await db.delete(
        'reminders',
        where: 'addiction_id = ?',
        whereArgs: [addictionId],
      );
      await db.delete(
        'milestones',
        where: 'addiction_id = ?',
        whereArgs: [addictionId],
      );
      await db.delete(
        'daily_surveys',
        where: 'addiction_id = ?',
        whereArgs: [addictionId],
      );

      // Delete the addiction
      await db.delete('addictions', where: 'id = ?', whereArgs: [addictionId]);

      // If this was the current addiction, update SharedPreferences
      final currentId = SharedPreferencesManager.getCurrentAddictionId();
      if (currentId == addictionId) {
        // Get another addiction to switch to
        final userId = SharedPreferencesManager.getUserId();
        final otherAddictions = await AddictionsTable.getByUserId(
          db,
          userId ?? -1,
        );

        if (otherAddictions.isNotEmpty) {
          await SharedPreferencesManager.setCurrentAddictionId(
            otherAddictions.first['id'] as int,
          );
        } else {
          await SharedPreferencesManager.clearAddictionData();
        }
      }

      await db.execute('COMMIT');
    } catch (e) {
      await db.execute('ROLLBACK');
      rethrow;
    }
  }

  /// Reorder addictions
  Future<void> reorderAddictions(List<Map<String, dynamic>> addictions) async {
    final db = await _dbHelper.database;

    for (int i = 0; i < addictions.length; i++) {
      await db.update(
        'addictions',
        {'position': i},
        where: 'id = ?',
        whereArgs: [addictions[i]['id']],
      );
    }

    // Save order to SharedPreferences
    final orderedIds = addictions.map((a) => a['id'] as int).toList();
    await SharedPreferencesManager.saveAddictionOrder(orderedIds);
  }
}
