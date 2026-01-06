import 'package:sqflite/sqflite.dart';

class HeroesTable {
  static const String tableName = 'heroes';

  /// Insert a new hero entry
  static Future<int> insert(Database db, Map<String, dynamic> hero) async {
    return await db.insert(tableName, hero);
  }

  /// Get hero entry by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get hero entries for a user
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

  /// Get current weekly heroes
  static Future<List<Map<String, dynamic>>> getWeeklyHeroes(Database db) async {
    return await db.query(
      tableName,
      where: "period_type = 'weekly'",
      orderBy: 'rank ASC',
      limit: 10,
    );
  }

  /// Get current monthly heroes
  static Future<List<Map<String, dynamic>>> getMonthlyHeroes(Database db) async {
    return await db.query(
      tableName,
      where: "period_type = 'monthly'",
      orderBy: 'rank ASC',
      limit: 10,
    );
  }

  /// Get leaderboard for a period
  static Future<List<Map<String, dynamic>>> getLeaderboard(
    Database db,
    String periodType, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'period_type = ?',
      whereArgs: [periodType],
      orderBy: 'rank ASC',
      limit: limit ?? 50,
    );
  }

  /// Update hero entry
  static Future<int> update(Database db, int id, Map<String, dynamic> hero) async {
    return await db.update(
      tableName,
      hero,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete hero entry
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get heroes created after a specific date (for sync)
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

  /// Get user's highest rank in a period type
  static Future<int?> getUserRank(Database db, int userId, String periodType) async {
    final result = await db.rawQuery(
      'SELECT rank FROM $tableName WHERE user_id = ? AND period_type = ? ORDER BY created_at DESC LIMIT 1',
      [userId, periodType],
    );
    if (result.isNotEmpty) {
      return result.first['rank'] as int?;
    }
    return null;
  }
}
