import 'package:sqflite/sqflite.dart';

class MilestonesTable {
  static const String tableName = 'milestones';

  /// Insert a new milestone
  static Future<int> insert(DatabaseExecutor db, Map<String, dynamic> milestone) async {
    return await db.insert(tableName, milestone);
  }

  /// Get milestone by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all milestones for an addiction
  static Future<List<Map<String, dynamic>>> getByAddictionId(
    Database db,
    int addictionId,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ?',
      whereArgs: [addictionId],
      orderBy: 'target_value ASC',
    );
  }

  /// Get achieved milestones
  static Future<List<Map<String, dynamic>>> getAchieved(
    Database db,
    int addictionId,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ? AND achieved_at IS NOT NULL',
      whereArgs: [addictionId],
      orderBy: 'achieved_at DESC',
    );
  }

  /// Get pending milestones
  static Future<List<Map<String, dynamic>>> getPending(
    Database db,
    int addictionId,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ? AND achieved_at IS NULL',
      whereArgs: [addictionId],
      orderBy: 'target_value ASC',
    );
  }

  /// Update milestone
  static Future<int> update(Database db, int id, Map<String, dynamic> milestone) async {
    return await db.update(
      tableName,
      milestone,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark milestone as achieved
  static Future<int> markAsAchieved(Database db, int id) async {
    return await db.update(
      tableName,
      {'achieved_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Reset milestone timer (set created_at to now)
  static Future<int> resetCreatedAt(Database db, int id) async {
    return await db.update(
      tableName,
      {'created_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete milestone
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get milestones by type
  static Future<List<Map<String, dynamic>>> getByType(
    Database db,
    int addictionId,
    String type,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ? AND type = ?',
      whereArgs: [addictionId, type],
      orderBy: 'target_value ASC',
    );
  }
}