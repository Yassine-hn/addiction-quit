import 'package:sqflite/sqflite.dart';

class NotificationsTable {
  static const String tableName = 'notifications';

  /// Insert a new notification
  static Future<int> insert(Database db, Map<String, dynamic> notification) async {
    return await db.insert(tableName, notification);
  }

  /// Get notification by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all notifications for a user
  static Future<List<Map<String, dynamic>>> getByUserId(
    Database db,
    int userId, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Get unread notifications for a user
  static Future<List<Map<String, dynamic>>> getUnreadByUserId(
    Database db,
    int userId, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Get notifications of a specific type
  static Future<List<Map<String, dynamic>>> getByType(
    Database db,
    int userId,
    String type, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, type],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Mark notification as read
  static Future<int> markAsRead(Database db, int id) async {
    return await db.update(
      tableName,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark all notifications as read for a user
  static Future<int> markAllAsRead(Database db, int userId) async {
    return await db.update(
      tableName,
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Delete notification
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all notifications for a user
  static Future<int> deleteByUserId(Database db, int userId) async {
    return await db.delete(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Count unread notifications
  static Future<int> countUnread(Database db, int userId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get notifications created after a specific date (for sync)
  static Future<List<Map<String, dynamic>>> getCreatedAfter(
    Database db,
    String dateTime,
  ) async {
    return await db.query(
      tableName,
      where: 'created_at > ?',
      whereArgs: [dateTime],
      orderBy: 'created_at ASC',
    );
  }
}
