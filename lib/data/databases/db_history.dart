// Migration history

import 'package:sqflite/sqflite.dart';

/// Database migration history and version management
class DatabaseHistory {
  // Current database version
  static const int currentVersion = 1;
  
  // Database name
  static const String databaseName = 'addiction_quit.db';
  
  /// Migration from version 0 to 1 (initial creation)
  static Future<void> migrateV0ToV1(Database db) async {
    await _createUsersTable(db);
    await _createAddictionsTable(db);
    await _createDailySurveysTable(db);
    await _createMilestonesTable(db);
    await _createRemindersTable(db);
    await _createActivityLogsTable(db);
  }
  
  /// Execute migrations based on version
  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await migrateV0ToV1(db);
    }
    
    // Future migrations
    // if (oldVersion < 2) {
    //   await migrateV1ToV2(db);
    // }
  }
  
  // Table creation methods
  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password_hash TEXT,
        dob TEXT,
        score INTEGER DEFAULT 0,
        avatar_url TEXT,
        bio TEXT,
        language TEXT,
        last_login_at TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');
  }
  
  static Future<void> _createAddictionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE addictions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        start_date TEXT NOT NULL,
        counter_start_at TEXT NOT NULL,
        slips INTEGER DEFAULT 0,
        goal_type TEXT NOT NULL,
        daily_target INTEGER,
        streak INTEGER DEFAULT 0,
        last_slip_at TEXT,
        status TEXT DEFAULT 'active',
        note TEXT,
        motivation TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_addictions_user_id ON addictions(user_id)');
    await db.execute('CREATE INDEX idx_addictions_status ON addictions(status)');
  }
  
  static Future<void> _createDailySurveysTable(Database db) async {
    await db.execute('''
      CREATE TABLE daily_surveys (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        addiction_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        slipped INTEGER DEFAULT 0,
        slip_amount INTEGER DEFAULT 0,
        difficulty TEXT,
        mood TEXT,
        urge_level INTEGER,
        triggers TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (addiction_id) REFERENCES addictions (id) ON DELETE CASCADE,
        UNIQUE(addiction_id, date)
      )
    ''');
    
    await db.execute('CREATE INDEX idx_daily_surveys_addiction_id ON daily_surveys(addiction_id)');
    await db.execute('CREATE INDEX idx_daily_surveys_date ON daily_surveys(date)');
  }
  
  static Future<void> _createMilestonesTable(Database db) async {
    await db.execute('''
      CREATE TABLE milestones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        addiction_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        target_value INTEGER NOT NULL,
        achieved_at TEXT,
        type TEXT DEFAULT 'milestone',
        icon_url TEXT,
        reward_points INTEGER DEFAULT 0,
        deadline TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (addiction_id) REFERENCES addictions (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_milestones_addiction_id ON milestones(addiction_id)');
  }
  
  static Future<void> _createRemindersTable(Database db) async {
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        addiction_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        repeat_daily INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (addiction_id) REFERENCES addictions (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_reminders_user_id ON reminders(user_id)');
    await db.execute('CREATE INDEX idx_reminders_addiction_id ON reminders(addiction_id)');
  }
  
  static Future<void> _createActivityLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE activity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action_type TEXT NOT NULL,
        meta TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id)');
    await db.execute('CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at)');
  }
}