import '../../data/databases/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/databases/tables/users_table.dart';
import '../../data/databases/tables/addictions_table.dart';
import '../../data/databases/tables/reminders_table.dart';
import '../../data/databases/tables/activity_logs_table.dart';
import '../../data/databases/tables/notifications_table.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

/// Service to handle signup synchronization between local and cloud databases
/// Responsible for:
/// 1. Preparing local user data for signup
/// 2. Updating local database after successful cloud signup
/// 3. Managing user ID transitions from local to cloud UUID
class SignupSyncService {
  /// Get local user data to send to cloud during signup
  /// Returns user data map with all fields except id and updated_at
  /// Keeps created_at, is_active, last_login_at and all profile fields
  Future<Map<String, dynamic>?> getLocalUserData() async {
    try {
      final db = await DatabaseHelper.instance.database;
      
      // Get all users (should only be one in local DB)
      final users = await UsersTable.getAll(db);
      
      if (users.isEmpty) {
        print('No local user found');
        return null;
      }
      
      // Get the first (and should be only) user
      final user = Map<String, dynamic>.from(users.first);
      
      // Remove id field - cloud will generate new UUID
      user.remove('id');
      
      // Remove updated_at - cloud will set this
      // Keep created_at - client-provided timestamp for when user was created locally
      user.remove('updated_at');
      
      print('Retrieved local user data: name=${user['name']}, email=${user['email']}, created_at=${user['created_at']}');
      return user;
    } catch (e) {
      print('Error getting local user data: $e');
      return null;
    }
  }

  /// Get current local user ID from SharedPreferences
  /// Returns the ID of the currently active user, not just the first row in the table
  Future<String?> getCurrentLocalUserId() async {
    try {
      return await SharedPreferencesHelper.getUserId();
    } catch (e) {
      print('Error getting current local user ID: $e');
      return null;
    }
  }

  /// Update local database after successful cloud signup
  /// 1. Updates all foreign keys in related tables to new cloud UUID
  /// 2. Deletes old local user record
  /// 3. Inserts new cloud user record
  /// 4. Updates SharedPreferences with new user ID
  Future<void> updateLocalAfterSignup({
    required String oldLocalUserId,
    required Map<String, dynamic> cloudUserData,
  }) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final newCloudUserId = cloudUserData['id'].toString();
      
      print('Updating local DB: $oldLocalUserId → $newCloudUserId');
      
      // Step 1: Update all foreign keys in related tables
      await _updateAllForeignKeys(db, oldLocalUserId, newCloudUserId);
      
      // Step 2: Delete old local user record
      await UsersTable.delete(db, oldLocalUserId);
      print('Deleted old local user: $oldLocalUserId');
      
      // Step 3: Insert new cloud user record
      // Convert bool fields to int (SQLite only accepts num/String/Uint8List)
      final convertedUserData = Map<String, dynamic>.from(cloudUserData);
      convertedUserData.forEach((key, value) {
        if (value is bool) {
          convertedUserData[key] = value ? 1 : 0;
        }
      });

      // Ensure required defaults so SQLite NOT NULL constraints are satisfied
      convertedUserData['created_at'] ??= DateTime.now().toIso8601String();
      convertedUserData['language'] ??= 'en';
      convertedUserData['is_active'] ??= 1; // already int/bool converted above
      
      await UsersTable.insert(db, convertedUserData);
      print('Inserted cloud user: $newCloudUserId');
      
      // Step 4: Update SharedPreferences with new user ID
      await SharedPreferencesHelper.saveUserId(newCloudUserId);
      print('Updated SharedPreferences with new user ID');
      
      print('✅ Local database successfully updated after signup');
    } catch (e) {
      print('❌ Error updating local database after signup: $e');
      rethrow;
    }
  }

  /// Update all foreign key references from old user ID to new cloud UUID
  Future<void> _updateAllForeignKeys(
    Database db,
    String oldUserId,
    String newUserId,
  ) async {
    print('Updating foreign keys: $oldUserId → $newUserId');

    // Temporarily disable foreign key enforcement
    await db.execute('PRAGMA foreign_keys = OFF');

    try {
      // Update addictions table
      try {
        await db.rawUpdate(
          'UPDATE ${AddictionsTable.tableName} SET user_id = ? WHERE user_id = ?',
          [newUserId, oldUserId],
        );
        print('✓ Updated addictions.user_id');
      } catch (e) {
        if (e.toString().contains('no such table')) {
          print('⚠ Skipped addictions (table does not exist)');
        } else {
          rethrow;
        }
      }

      // Update reminders table
      try {
        await db.rawUpdate(
          'UPDATE ${RemindersTable.tableName} SET user_id = ? WHERE user_id = ?',
          [newUserId, oldUserId],
        );
        print('✓ Updated reminders.user_id');
      } catch (e) {
        if (e.toString().contains('no such table')) {
          print('⚠ Skipped reminders (table does not exist)');
        } else {
          rethrow;
        }
      }

      // Update activity_logs table
      try {
        await db.rawUpdate(
          'UPDATE ${ActivityLogsTable.tableName} SET user_id = ? WHERE user_id = ?',
          [newUserId, oldUserId],
        );
        print('✓ Updated activity_logs.user_id');
      } catch (e) {
        if (e.toString().contains('no such table')) {
          print('⚠ Skipped activity_logs (table does not exist)');
        } else {
          rethrow;
        }
      }

      // Update notifications table 
      try {
        await db.rawUpdate(
          'UPDATE ${NotificationsTable.tableName} SET user_id = ? WHERE user_id = ?',
          [newUserId, oldUserId],
        );
        print('✓ Updated notifications.user_id');
      } catch (e) {
        if (e.toString().contains('no such table')) {
          print('⚠ Skipped notifications (table does not exist in this database version)');
        } else {
          rethrow;
        }
      }

      print('✅ All foreign keys updated (skipped missing tables)');
    } finally {
      // Re-enable foreign key enforcement
      await db.execute('PRAGMA foreign_keys = ON');
    }
  }
}