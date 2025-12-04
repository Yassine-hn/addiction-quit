// Main database helper

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_base.dart';
import 'db_history.dart';

/// Main database helper implementing DatabaseBase
class DatabaseHelper extends DatabaseBase {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB(DatabaseHistory.databaseName);
    return _database!;
  }

  @override
  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: DatabaseHistory.currentVersion,
      onCreate: createTables,
      onUpgrade: onUpgrade,
      onConfigure: (db) async {
        // Enable foreign keys
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  @override
  Future<void> createTables(Database db, int version) async {
    await DatabaseHistory.migrateV0ToV1(db);
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await DatabaseHistory.migrate(db, oldVersion, newVersion);
  }

  @override
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  @override
  Future<void> clearAllTables() async {
    final db = await instance.database;
    
    // Delete in reverse order of dependencies
    await db.delete('activity_logs');
    await db.delete('reminders');
    await db.delete('milestones');
    await db.delete('daily_surveys');
    await db.delete('addictions');
    await db.delete('users');
  }

  @override
  Future<int> getDatabaseVersion() async {
    final db = await instance.database;
    return await db.getVersion();
  }
  
  /// Delete database (for testing or reset)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseHistory.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
  
  /// Backup database
  Future<String> backupDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseHistory.databaseName);
    final backupPath = join(dbPath, 'backup_${DateTime.now().millisecondsSinceEpoch}.db');
    
    final db = await instance.database;
    await db.close();
    
    // Copy file logic here (you'll need to implement based on platform)
    
    _database = null;
    return backupPath;
  }
}