import 'package:sqflite/sqflite.dart';

class PostReactionsTable {
  static const String tableName = 'post_reactions';

  /// Insert a new reaction
  static Future<int> insert(Database db, Map<String, dynamic> reaction) async {
    return await db.insert(
      tableName,
      reaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get reaction by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all reactions for a post
  static Future<List<Map<String, dynamic>>> getByPostId(Database db, int postId) async {
    return await db.query(
      tableName,
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: 'created_at DESC',
    );
  }

  /// Get user's reaction to a post
  static Future<Map<String, dynamic>?> getUserReaction(
    Database db,
    int postId,
    Object userId,
  ) async {
    final results = await db.query(
      tableName,
      where: 'post_id = ? AND user_id = ?',
      whereArgs: [postId, userId.toString()],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all reactions by a user
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

  /// Delete reaction
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete user's reaction to a post
  static Future<int> deleteUserReaction(
    Database db,
    int postId,
    Object userId,
  ) async {
    return await db.delete(
      tableName,
      where: 'post_id = ? AND user_id = ?',
      whereArgs: [postId, userId.toString()],
    );
  }

  /// Count reactions for a post
  static Future<int> countByPostId(Database db, int postId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE post_id = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get reactions created after a specific date (for sync)
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
