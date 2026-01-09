// Migration history

import 'package:sqflite/sqflite.dart';

/// Database migration history and version management
class DatabaseHistory {
  // Current database version
  static const int currentVersion = 3;
  
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
    
    if (oldVersion < 2) {
      await migrateV1ToV2(db);
    }
    
    if (oldVersion < 3) {
      await migrateV2ToV3(db);
    }
  }
  
  /// Migration from version 1 to 2 (add time_saved_per_day and money_saved_per_day to addictions)
  static Future<void> migrateV1ToV2(Database db) async {
    await db.execute('''
      ALTER TABLE addictions 
      ADD COLUMN time_saved_per_day INTEGER DEFAULT 0
    ''');
    
    await db.execute('''
      ALTER TABLE addictions 
      ADD COLUMN money_saved_per_day REAL
    ''');
  }

  /// Migration from version 2 to 3 (add notifications)
  static Future<void> migrateV2ToV3(Database db) async {
    await _createNotificationsTable(db);
  }
  
  // Table creation methods
  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        password_hash TEXT,
        dob TEXT,
        score INTEGER DEFAULT 0,
        avatar_url TEXT,
        bio TEXT,
        language TEXT DEFAULT 'en',
        last_login_at TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }
  
  static Future<void> _createAddictionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE addictions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        addiction_type TEXT NOT NULL,
        start_date TEXT NOT NULL,
        counter_start_at TEXT NOT NULL,
        target_date TEXT,
        slips INTEGER DEFAULT 0,
        goal_type TEXT NOT NULL CHECK (goal_type IN ('daily','weekly','total')),
        daily_target INTEGER CHECK (daily_target IS NULL OR daily_target >= 0),
        weekly_target INTEGER CHECK (weekly_target IS NULL OR weekly_target >= 0),
        streak INTEGER DEFAULT 0,
        last_slip_at TEXT,
        status TEXT DEFAULT 'active' CHECK (status IN ('active','paused','completed','archived')),
        note TEXT,
        motivation TEXT,
        time_saved_per_day INTEGER NOT NULL DEFAULT 0,
        money_saved_per_day REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        CHECK (streak >= 0),
        CHECK (slips >= 0),
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
        slipped INTEGER NOT NULL DEFAULT 0,
        slip_amount INTEGER DEFAULT 0,
        difficulty TEXT CHECK (difficulty IN ('easy','medium','hard','very_hard')),
        mood TEXT NOT NULL CHECK (mood IN ('happy','sad','anxious','calm','stressed','motivated','frustrated','confident')),
        urge_level INTEGER NOT NULL CHECK (urge_level >= 0 AND urge_level <= 10),
        triggers TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (addiction_id) REFERENCES addictions (id) ON DELETE CASCADE,
        UNIQUE(addiction_id, date),
        CHECK ((slipped = 0 AND (slip_amount = 0 OR slip_amount IS NULL)) OR (slipped = 1 AND slip_amount > 0))
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
        target_value INTEGER NOT NULL CHECK (target_value > 0),
        achieved_at TEXT,
        is_achieved INTEGER DEFAULT 0,
        type TEXT DEFAULT 'milestone' CHECK (type IN ('milestone','goal','achievement')),
        icon_url TEXT,
        reward_points INTEGER NOT NULL DEFAULT 0 CHECK (reward_points >= 0),
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
        user_id TEXT NOT NULL,
        addiction_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        repeat_daily INTEGER DEFAULT 1,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (addiction_id) REFERENCES addictions (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_reminders_user_id ON reminders(user_id)');
    await db.execute('CREATE INDEX idx_reminders_addiction_id ON reminders(addiction_id)');
    await db.execute('CREATE INDEX idx_reminders_is_active ON reminders(is_active)');
  }
  
  static Future<void> _createActivityLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE activity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        action_type TEXT NOT NULL CHECK (action_type IN ('addiction_created','milestone_achieved','survey_completed','slip_recorded','goal_updated','login','logout')),
        meta TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id)');
    await db.execute('CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at)');
  }

  static Future<void> _createNotificationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('milestone','reminder','community','achievement','hero','system')),
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        data TEXT,
        is_read INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('CREATE INDEX idx_notifications_user_id ON notifications(user_id)');
    await db.execute('CREATE INDEX idx_notifications_is_read ON notifications(is_read)');
    await db.execute('CREATE INDEX idx_notifications_created_at ON notifications(created_at)');
  }
}