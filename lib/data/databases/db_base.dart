// Abstract base class

import 'package:sqflite/sqflite.dart';

/// Abstract base class for database operations
abstract class DatabaseBase {
  /// Get database instance
  Future<Database> get database;
  
  /// Initialize database
  Future<Database> initDB(String filePath);
  
  /// Create all tables
  Future<void> createTables(Database db, int version);
  
  /// Upgrade database schema
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);
  
  /// Close database connection
  Future<void> close();
  
  /// Clear all tables (for testing/reset)
  Future<void> clearAllTables();
  
  /// Get database version
  Future<int> getDatabaseVersion();
}