import 'package:sqflite/sqflite.dart';

class ActivityLogsTable {
  static const String tableName = 'activity_logs';

  /// Insert a new activity log
  static Future<int> insert(Database db, Map<String, dynamic> log) async {
    return await db.insert(tableName, log);
  }

  /// Get activity log by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all activity logs for a user
  static Future<List<Map<String, dynamic>>> getByUserId(
    Database db,
    Object userId, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId.toString()],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Get activity logs by type
  static Future<List<Map<String, dynamic>>> getByType(
    Database db,
    Object userId,
    String actionType,
  ) async {
    return await db.query(
      tableName,
      where: 'user_id = ? AND action_type = ?',
      whereArgs: [userId.toString(), actionType],
      orderBy: 'created_at DESC',
    );
  }

  /// Get activity logs in date range
  static Future<List<Map<String, dynamic>>> getByDateRange(
    Database db,
    Object userId,
    String startDate,
    String endDate,
  ) async {
    return await db.query(
      tableName,
      where: 'user_id = ? AND created_at BETWEEN ? AND ?',
      whereArgs: [userId.toString(), startDate, endDate],
      orderBy: 'created_at DESC',
    );
  }

  /// Delete activity log
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete old activity logs (e.g., older than 90 days)
  static Future<int> deleteOlderThan(Database db, String date) async {
    return await db.delete(
      tableName,
      where: 'created_at < ?',
      whereArgs: [date],
    );
  }

  /// Log an action
  static Future<int> logAction(
    Database db,
    Object userId,
    String actionType,
    String? meta,
  ) async {
    return await insert(db, {
      'user_id': userId.toString(),
      'action_type': actionType,
      'meta': meta,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}