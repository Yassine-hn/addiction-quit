import 'package:sqflite/sqflite.dart';

class UsersTable {
  static const String tableName = 'users';

  /// Insert a new user; ensures string primary key
  static Future<String> insert(DatabaseExecutor db, Map<String, dynamic> user) async {
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
  static Future<int> delete(DatabaseExecutor db, Object id) async {
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

  /// Update authentication info (email and password hash)
  static Future<int> updateAuthInfo(
    Database db,
    Object id, {
    String? email,
    String? passwordHash,
  }) async {
    final data = <String, dynamic>{};
    
    if (email != null) {
      data['email'] = email;
    }
    if (passwordHash != null) {
      data['password_hash'] = passwordHash;
    }
    
    if (data.isEmpty) {
      return 0;
    }
    
    data['updated_at'] = DateTime.now().toIso8601String();
    
    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  /// Update user name
  static Future<int> updateName(Database db, Object id, String name) async {
    return await db.update(
      tableName,
      {
        'name': name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  /// Update user ID (used when migrating from local ID to cloud UUID)
  /// Note: This is a complex operation that should be followed by updating
  /// all foreign keys in related tables
  static Future<void> updateUserId(
    Database db,
    Object oldId,
    Object newId,
  ) async {
    // Get the user data
    final user = await getById(db, oldId);
    
    if (user == null) {
      throw Exception('User with id $oldId not found');
    }
    
    // Update the id
    user['id'] = newId.toString();
    user['updated_at'] = DateTime.now().toIso8601String();
    
    // Delete old record and insert with new ID
    await delete(db, oldId);
    await db.insert(tableName, user, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}