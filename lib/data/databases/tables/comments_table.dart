import 'package:sqflite/sqflite.dart';

class CommentsTable {
  static const String tableName = 'comments';

  /// Insert a new comment
  static Future<int> insert(Database db, Map<String, dynamic> comment) async {
    return await db.insert(tableName, comment);
  }

  /// Get comment by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all comments for a post
  static Future<List<Map<String, dynamic>>> getByPostId(
    Database db,
    int postId, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: 'created_at ASC',
      limit: limit,
    );
  }

  /// Get all comments by a user
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

  /// Update comment
  static Future<int> update(Database db, int id, Map<String, dynamic> comment) async {
    return await db.update(
      tableName,
      comment,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete comment
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Count comments for a post
  static Future<int> countByPostId(Database db, int postId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE post_id = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get comments created after a specific date (for sync)
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
