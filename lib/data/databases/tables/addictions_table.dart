import 'package:sqflite/sqflite.dart';

class AddictionsTable {
  static const String tableName = 'addictions';

  /// Insert a new addiction
  static Future<int> insert(DatabaseExecutor db, Map<String, dynamic> addiction) async {
    return await db.insert(tableName, addiction);
  }

  /// Get addiction by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all addictions for a user
  static Future<List<Map<String, dynamic>>> getByUserId(
    Database db,
    Object userId, {
    String? status,
  }) async {
    // user_id is stored as TEXT; normalize to string to avoid type mismatches
    final userIdArg = userId.toString();

    String? whereClause = 'user_id = ?';
    List<dynamic> whereArgs = [userIdArg];

    if (status != null) {
      whereClause += ' AND status = ?';
      whereArgs.add(status);
    }

    return await db.query(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
  }

  /// Get active addictions for a user
  static Future<List<Map<String, dynamic>>> getActiveByUserId(
    Database db,
    Object userId,
  ) async {
    return await getByUserId(db, userId, status: 'active');
  }

  /// Update addiction
  static Future<int> update(Database db, int id, Map<String, dynamic> addiction) async {
    return await db.update(
      tableName,
      addiction,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete addiction
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update streak
  static Future<int> updateStreak(Database db, int id, int streak) async {
    return await db.update(
      tableName,
      {'streak': streak},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Record a slip
  static Future<int> recordSlip(Database db, int id, {int amount = 1}) async {
    final addiction = await getById(db, id);
    if (addiction == null) return 0;

    final currentSlips = addiction['slips'] as int? ?? 0;
    final newSlipTotal = currentSlips + (amount <= 0 ? 1 : amount);

    return await db.update(
      tableName,
      {
        'slips': newSlipTotal,
        'streak': 0,
        'last_slip_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> resetCounter(Database db, int id) async {
    return await db.update(
      tableName,
      {
        'counter_start_at': DateTime.now().toIso8601String(),
        'slips': 0,
        'streak': 0,
        'last_slip_at': null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update status
  static Future<int> updateStatus(Database db, int id, String status) async {
    return await db.update(
      tableName,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update time saved (in minutes)
  static Future<int> updateTimeSavedPerDay(Database db, int id, int timeSavedMinutes) async {
    return await db.update(
      tableName,
      {'time_saved_per_day': timeSavedMinutes},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update money saved per day
  static Future<int> updateMoneySavedPerDay(Database db, int id, double? moneySavedPerDay) async {
    return await db.update(
      tableName,
      {'money_saved_per_day': moneySavedPerDay},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}