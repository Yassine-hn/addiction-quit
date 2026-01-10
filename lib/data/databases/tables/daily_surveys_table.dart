import 'package:sqflite/sqflite.dart';

class DailySurveysTable {
  static const String tableName = 'daily_surveys';

  /// Insert a new daily survey
  static Future<int> insert(DatabaseExecutor db, Map<String, dynamic> survey) async {
    return await db.insert(
      tableName,
      survey,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get survey by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get surveys for an addiction
  static Future<List<Map<String, dynamic>>> getByAddictionId(
    Database db,
    int addictionId, {
    int? limit,
  }) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ?',
      whereArgs: [addictionId],
      orderBy: 'date DESC',
      limit: limit,
    );
  }

  /// Get survey for a specific date
  static Future<Map<String, dynamic>?> getByDate(
    Database db,
    int addictionId,
    String date,
  ) async {
    final results = await db.query(
      tableName,
      where: 'addiction_id = ? AND date = ?',
      whereArgs: [addictionId, date],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get surveys in date range
  static Future<List<Map<String, dynamic>>> getByDateRange(
    Database db,
    int addictionId,
    String startDate,
    String endDate,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [addictionId, startDate, endDate],
      orderBy: 'date ASC',
    );
  }

  /// Update survey
  static Future<int> update(Database db, int id, Map<String, dynamic> survey) async {
    return await db.update(
      tableName,
      survey,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete survey
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get surveys where user slipped
  static Future<List<Map<String, dynamic>>> getSlipDays(
    Database db,
    int addictionId,
  ) async {
    return await db.query(
      tableName,
      where: 'addiction_id = ? AND slipped = 1',
      whereArgs: [addictionId],
      orderBy: 'date DESC',
    );
  }

  /// Get average mood for addiction
  static Future<double?> getAverageMood(Database db, int addictionId) async {
    final result = await db.rawQuery('''
      SELECT AVG(
        CASE mood
          WHEN 'bad' THEN 1
          WHEN 'neutral' THEN 2
          WHEN 'good' THEN 3
          WHEN 'great' THEN 4
        END
      ) as avg_mood
      FROM $tableName
      WHERE addiction_id = ? AND mood IS NOT NULL
    ''', [addictionId]);
    
    return result.first['avg_mood'] as double?;
  }

  /// Get average urge level
  static Future<double?> getAverageUrgeLevel(
    Database db,
    int addictionId,
  ) async {
    final result = await db.rawQuery('''
      SELECT AVG(urge_level) as avg_urge
      FROM $tableName
      WHERE addiction_id = ? AND urge_level IS NOT NULL
    ''', [addictionId]);
    
    return result.first['avg_urge'] as double?;
  }
}