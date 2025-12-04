import 'package:sqflite/sqflite.dart';

class UsersTable {
  static const String tableName = 'users';

  /// Insert a new user
  static Future<int> insert(Database db, Map<String, dynamic> user) async {
    return await db.insert(
      tableName,
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get user by ID
  static Future<Map<String, dynamic>?> getById(Database db, int id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get user by email
  static Future<Map<String, dynamic>?> getByEmail(Database db, String email) async {
    final results = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update user
  static Future<int> update(Database db, int id, Map<String, dynamic> user) async {
    return await db.update(
      tableName,
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete user
  static Future<int> delete(Database db, int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get all users (usually only one in local DB)
  static Future<List<Map<String, dynamic>>> getAll(Database db) async {
    return await db.query(tableName);
  }

  /// Update last login
  static Future<int> updateLastLogin(Database db, int id) async {
    return await db.update(
      tableName,
      {'last_login_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update score
  static Future<int> updateScore(Database db, int id, int score) async {
    return await db.update(
      tableName,
      {'score': score},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}