import 'dart:math';
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import '../databases/tables/addictions_table.dart';
import '../databases/tables/daily_surveys_table.dart';
import '../databases/tables/milestones_table.dart';
import '../databases/tables/posts_table.dart';
import '../databases/tables/notifications_table.dart';
import '../databases/tables/reminders_table.dart';
import '../repositories/settings_repository.dart';

class DatabaseSeeder {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SettingsRepository _settingsHelper = SettingsRepository();
  final random = Random();

  // Sample data
  final List<String> addictionTypes = [
    'No Alcohol',
    'Quit Smoking',
    'No Caffeine',
    'No Sugar',
    'No Social Media',
    'No Gaming',
    'Exercise Daily',
    'No Fast Food',
    'No Gambling',
    'No Shopping',
  ];

  final List<String> moods = ['great', 'good', 'okay', 'bad', 'terrible'];
  final List<String> notes = [
    'Feeling strong today!',
    'Had some cravings but stayed strong',
    'This is getting easier',
    'Rough day but I made it',
    'Proud of my progress',
    'Feeling motivated',
    'One day at a time',
    'Almost gave in but resisted',
    'Best decision I ever made',
    'Struggling but not giving up',
  ];

  final List<Map<String, dynamic>> milestoneTemplates = [
    {'title': '1 Day Clean', 'days': 1},
    {'title': '3 Days Clean', 'days': 3},
    {'title': '1 Week Clean', 'days': 7},
    {'title': '2 Weeks Clean', 'days': 14},
    {'title': '1 Month Clean', 'days': 30},
    {'title': '2 Months Clean', 'days': 60},
    {'title': '3 Months Clean', 'days': 90},
    {'title': '6 Months Clean', 'days': 180},
    {'title': '1 Year Clean', 'days': 365},
  ];

  Future<void> seed() async {
    final db = await _dbHelper.database;
    
    print('🌱 Starting database seeding...');
    
    // 1. Clear existing data
    await _dbHelper.clearAllTables();
    print('✅ Cleared existing data');

    // 2. Create 4 Users
    final users = [
      {'name': 'John Smith', 'email': 'john@example.com', 'dob': '1990-03-15', 'score': 450, 'addictionCount': 5},
      {'name': 'Sarah Johnson', 'email': 'sarah@example.com', 'dob': '1985-07-22', 'score': 320, 'addictionCount': 3},
      {'name': 'Mike Chen', 'email': 'mike@example.com', 'dob': '1992-11-08', 'score': 180, 'addictionCount': 1},
      {'name': 'Emma Davis', 'email': 'emma@example.com', 'dob': '1988-05-30', 'score': 520, 'addictionCount': 4},
    ];

    final userIds = <String>[];
    for (var userData in users) {
      final userId = await UsersTable.insert(db, {
        'name': userData['name'],
        'email': userData['email'],
        'password_hash': 'hashed_password_${userData['name']}',
        'dob': userData['dob'],
        'score': userData['score'],
        'language': 'en',
        'is_active': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      userIds.add(userId);
    }
    print('✅ Created ${userIds.length} users');

    // 3. Create 20 Addictions (distributed among users: 5, 3, 1, 4)
    final addictionIds = <int>[];
    int addictionIndex = 0;
    
    for (int userIdx = 0; userIdx < users.length; userIdx++) {
      final String userId = userIds[userIdx];
      final addictionCount = users[userIdx]['addictionCount'] as int;
      
      for (int i = 0; i < addictionCount; i++) {
        final daysAgo = random.nextInt(90) + 10; // 10-100 days ago
        final startDate = DateTime.now().subtract(Duration(days: daysAgo));
        final streak = random.nextInt(daysAgo);
        final slips = random.nextInt(5);
        
        final addictionId = await AddictionsTable.insert(db, {
          'user_id': userId,
          'addiction_type': addictionTypes[addictionIndex % addictionTypes.length],
          'start_date': startDate.toIso8601String(),
          'counter_start_at': startDate.toIso8601String(),
          'goal_type': 'abstinence',
          'streak': streak,
          'slips': slips,
          'status': 'active',
          'created_at': startDate.toIso8601String(),
        });
        
        if (slips > 0) {
          await AddictionsTable.update(db, addictionId, {
            'last_slip_at': startDate.add(Duration(days: random.nextInt(daysAgo))).toIso8601String(),
          });
        }
        
        addictionIds.add(addictionId);
        addictionIndex++;
      }
    }
    print('✅ Created ${addictionIds.length} addictions');

    // 4. Create 20 Surveys for each addiction
    int totalSurveys = 0;
    for (var addictionId in addictionIds) {
      final addiction = await db.query('addictions', where: 'id = ?', whereArgs: [addictionId], limit: 1);
      if (addiction.isEmpty) continue;
      
      final startDate = DateTime.parse(addiction.first['start_date'] as String);
      final daysAgo = DateTime.now().difference(startDate).inDays;
      
      for (int i = 0; i < min(20, daysAgo); i++) {
        final surveyDate = startDate.add(Duration(days: i));
        if (surveyDate.isAfter(DateTime.now())) break;
        
        final isSlip = random.nextInt(20) == 0; // 5% chance of slip
        
        await DailySurveysTable.insert(db, {
          'addiction_id': addictionId,
          'date': surveyDate.toIso8601String().substring(0, 10),
          'slipped': isSlip ? 1 : 0,
          'mood': isSlip ? moods[3] : moods[random.nextInt(3)],
          'urge_level': random.nextInt(10),
          'note': isSlip ? 'Had a setback today' : notes[random.nextInt(notes.length)],
          'created_at': surveyDate.toIso8601String(),
        });
        totalSurveys++;
      }
    }
    print('✅ Created $totalSurveys daily surveys');

    // 5. Create 60 Milestones (3 per addiction, some achieved, some pending)
    int totalMilestones = 0;
    for (var addictionId in addictionIds) {
      final addiction = await db.query('addictions', where: 'id = ?', whereArgs: [addictionId], limit: 1);
      if (addiction.isEmpty) continue;
      
      final startDate = DateTime.parse(addiction.first['start_date'] as String);
      final daysAgo = DateTime.now().difference(startDate).inDays;
      
      // Create 3 milestones per addiction
      for (int i = 0; i < 3; i++) {
        final milestone = milestoneTemplates[min(i + random.nextInt(3), milestoneTemplates.length - 1)];
        final targetDays = milestone['days'] as int;
        final isAchieved = daysAgo >= targetDays && random.nextBool();
        
        await MilestonesTable.insert(db, {
          'addiction_id': addictionId,
          'title': milestone['title'],
          'target_value': targetDays,
          'achieved_at': isAchieved ? startDate.add(Duration(days: targetDays)).toIso8601String() : null,
          'created_at': startDate.toIso8601String(),
        });
        totalMilestones++;
      }
    }
    print('✅ Created $totalMilestones milestones');

    // 6. Create Notifications for each user (3-5 per user)
    int totalNotifications = 0;
    final notificationTypes = ['milestone', 'reminder', 'achievement', 'system'];
    final notificationMessages = [
      {'type': 'milestone', 'title': '🎉 Milestone Achieved!', 'message': 'Congratulations on reaching 7 days clean!'},
      {'type': 'reminder', 'title': '⏰ Daily Check-in', 'message': "Don't forget to log your daily survey"},
      {'type': 'achievement', 'title': '🏆 New Achievement', 'message': 'You earned 50 points!'},
      {'type': 'system', 'title': '💡 Tip of the Day', 'message': 'Stay hydrated and get enough sleep'},
      {'type': 'milestone', 'title': '🎯 Halfway There!', 'message': "You're halfway to your next milestone!"},
    ];
    
    for (var userId in userIds) {
      final notifCount = random.nextInt(3) + 3; // 3-5 notifications
      for (int i = 0; i < notifCount; i++) {
        final notif = notificationMessages[random.nextInt(notificationMessages.length)];
        await NotificationsTable.insert(db, {
          'user_id': userId,
          'type': notif['type'],
          'title': notif['title'],
          'message': notif['message'],
          'is_read': random.nextBool() ? 1 : 0,
          'created_at': DateTime.now().subtract(Duration(days: random.nextInt(7))).toIso8601String(),
        });
        totalNotifications++;
      }
    }
    print('✅ Created $totalNotifications notifications');

    // 7. Create Reminders for each user (2-4 per user)
    int totalReminders = 0;
    for (int userIdx = 0; userIdx < userIds.length; userIdx++) {
      final String userId = userIds[userIdx];
      
      // Get addictions for this user
      final userAddictions = await db.query('addictions', where: 'user_id = ?', whereArgs: [userId]);
      if (userAddictions.isEmpty) continue;
      
      final reminderCount = random.nextInt(3) + 2; // 2-4 reminders
      for (int i = 0; i < reminderCount && i < userAddictions.length; i++) {
        final addictionId = userAddictions[i]['id'] as int;
        final hour = random.nextInt(12) + 8; // 8 AM - 8 PM
        final minute = random.nextInt(60);
        
        await RemindersTable.insert(db, {
          'user_id': userId,
          'addiction_id': addictionId,
          'reminder_time': '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
          'repeat_daily': 1,
          'is_active': random.nextBool() ? 1 : 1, // Most active
          'created_at': DateTime.now().subtract(Duration(days: random.nextInt(30))).toIso8601String(),
        });
        totalReminders++;
      }
    }
    print('✅ Created $totalReminders reminders');

    // 8. Set active addiction for first user
    if (addictionIds.isNotEmpty) {
      await _settingsHelper.saveCurrentAddictionId(addictionIds.first);
    }
    
    print('');
    print('🎉 Seeding complete!');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📊 Summary:');
    print('   👥 Users: ${userIds.length}');
    print('   🎯 Addictions: ${addictionIds.length}');
    print('   📝 Surveys: $totalSurveys');
    print('   🏆 Milestones: $totalMilestones');
    print('   🔔 Notifications: $totalNotifications');
    print('   ⏰ Reminders: $totalReminders');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  int min(int a, int b) => a < b ? a : b;
}
