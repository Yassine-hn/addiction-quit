import 'package:sqflite/sqflite.dart';

class PostsTable {
  static const String tableName = 'posts';

  /// Insert a new post
  static Future<int> insert(Database db, Map<String, dynamic> post) async {
    return await db.insert(tableName, post);
  }

  /// Get post by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all posts for a user
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

  /// Get all public posts (feed)
  static Future<List<Map<String, dynamic>>> getPublicFeed({
    required Database db,
    int? limit,
    int? offset,
  }) async {
    return await db.query(
      tableName,
      where: "visibility = 'public'",
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
  }

  /// Get posts with visibility filter
  static Future<List<Map<String, dynamic>>> getByVisibility(
    Database db,
    String visibility, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'visibility = ?',
      whereArgs: [visibility],
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  /// Update post
  static Future<int> update(Database db, int id, Map<String, dynamic> post) async {
    return await db.update(
      tableName,
      post,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update comment count
  static Future<int> updateCommentCount(Database db, int id, int count) async {
    return await db.update(
      tableName,
      {'comment_count': count},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update reaction count
  static Future<int> updateReactionCount(Database db, int id, int count) async {
    return await db.update(
      tableName,
      {'reaction_count': count},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete post
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get posts created after a specific date (for sync)
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
