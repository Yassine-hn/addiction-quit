import 'package:sqflite/sqflite.dart';

class RemindersTable {
  static const String tableName = 'reminders';

  /// Insert a new reminder
  static Future<int> insert(Database db, Map<String, dynamic> reminder) async {
    return await db.insert(tableName, reminder);
  }

  /// Get reminder by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all reminders for a user
  static Future<List<Map<String, dynamic>>> getByUserId(
    Database db,
    Object userId,
  ) async {
    return await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId.toString()],
      orderBy: 'reminder_time ASC',
    );
  }

  /// Get reminders for an addiction
  static Future<List<Map<String, dynamic>>> getByAddictionId(
    Database db,
    int addictionId,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ?',
      whereArgs: [addictionId],
      orderBy: 'reminder_time ASC',
    );
  }

  /// Get daily reminders
  static Future<List<Map<String, dynamic>>> getDailyReminders(
    Database db,
    Object userId,
  ) async {
    return await db.query(
      tableName,
      where: 'user_id = ? AND repeat_daily = 1',
      whereArgs: [userId.toString()],
      orderBy: 'reminder_time ASC',
    );
  }

  /// Update reminder
  static Future<int> update(Database db, int id, Map<String, dynamic> reminder) async {
    return await db.update(
      tableName,
      reminder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete reminder
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all reminders for an addiction
  static Future<int> deleteByAddictionId(Database db, int addictionId) async {
    return await db.delete(
      tableName,
      where: 'addiction_id = ?',
      whereArgs: [addictionId],
    );
  }
}