import 'package:sqflite/sqflite.dart';

class UsersTable {
  static const String tableName = 'users';

  /// Insert a new user; ensures string primary key
  static Future<String> insert(Database db, Map<String, dynamic> user) async {
    final data = Map<String, dynamic>.from(user);
    final id = data['id']?.toString() ?? 'user_${DateTime.now().microsecondsSinceEpoch}';
    data['id'] = id;

    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  /// Get user by ID
  static Future<Map<String, dynamic>?> getById(Database db, Object id) async {
    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id.toString()],
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
  static Future<int> update(Database db, Object id, Map<String, dynamic> user) async {
    return await db.update(
      tableName,
      user,
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  /// Delete user
  static Future<int> delete(Database db, Object id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  /// Get all users (usually only one in local DB)
  static Future<List<Map<String, dynamic>>> getAll(Database db) async {
    return await db.query(tableName);
  }

  /// Update last login
  static Future<int> updateLastLogin(Database db, Object id) async {
    return await db.update(
      tableName,
      {'last_login_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  /// Update score
  static Future<int> updateScore(Database db, Object id, int score) async {
    return await db.update(
      tableName,
      {'score': score},
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }
}