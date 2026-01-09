import 'dart:math';
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import '../databases/tables/addictions_table.dart';
import '../databases/tables/daily_surveys_table.dart';
import '../databases/tables/milestones_table.dart';
import '../databases/tables/posts_table.dart';
import '../repositories/settings_repository.dart';

class DatabaseSeeder {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SettingsRepository _settingsHelper = SettingsRepository();

  Future<void> seed() async {
    final db = await _dbHelper.database;
    
    // 1. Clear existing data
    await _dbHelper.clearAllTables();

    // 2. Create User
    final userId = await UsersTable.insert(db, {
      'name': 'Test User',
      'email': 'test@example.com',
      'password_hash': 'hash',
      'dob': '1990-01-15',
      'score': 150,
      'language': 'en',
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
    });

    // 3. Create Addictions
    
    // Addiction 1: Current Focus (e.g., No Alcohol)
    // Started 30 days ago
    final start1 = DateTime.now().subtract(const Duration(days: 30));
    final addiction1Id = await AddictionsTable.insert(db, {
      'user_id': userId,
      'addiction_type': 'No Alcohol',
      'start_date': start1.toIso8601String(),
      'counter_start_at': start1.toIso8601String(),
      'goal_type': 'abstinence',
      'streak': 30, // Assuming clean, but we might simulate slips
      'status': 'active',
      'created_at': start1.toIso8601String(),
    });

    // Addiction 2: Another one (e.g., Quit Smoking)
    // Started 5 days ago
    final start2 = DateTime.now().subtract(const Duration(days: 5));
    final addiction2Id = await AddictionsTable.insert(db, {
      'user_id': userId,
      'addiction_type': 'Quit Smoking',
      'start_date': start2.toIso8601String(),
      'counter_start_at': start2.toIso8601String(),
      'goal_type': 'abstinence',
      'streak': 5,
      'status': 'active',
      'created_at': start2.toIso8601String(),
    });

    // 4. Create Surveys (History) for Addiction 1
    // Let's simulate:
    // Days 1-10: Clean
    // Day 11: Slip
    // Days 12-30: Clean (Current streak = 19)
    
    // Update Streak for addiction 1 to 19 actually
    await AddictionsTable.updateStreak(db, addiction1Id, 19);
    // Add slip record
    final slipDate = start1.add(const Duration(days: 10)); // Day 11
    await AddictionsTable.update(db, addiction1Id, {
        'last_slip_at': slipDate.toIso8601String(),
        'slips': 1,
    });


    final random = Random();
    
    for (int i = 0; i < 30; i++) {
        final date = start1.add(Duration(days: i));
        // Skip future
        if (date.isAfter(DateTime.now())) break;
        
        // Day 11 is a slip
        bool isSlip = (i == 10);
        
        // Randomly skip some days (empty/no survey) to test formatting
        // if (random.nextBool() && i % 5 == 0 && !isSlip) continue; 

        await DailySurveysTable.insert(db, {
            'addiction_id': addiction1Id,
            'date': date.toIso8601String().substring(0, 10), // YYYY-MM-DD
            'slipped': isSlip ? 1 : 0,
            'mood': isSlip ? 'bad' : (random.nextBool() ? 'good' : 'great'),
            'urge_level': random.nextInt(10),
            'note': isSlip ? 'Had a bad day...' : 'Feeling good!',
            'created_at': date.toIso8601String(),
        });
    }

    // 5. Create Milestones for Addiction 1
    
    // Past milestone
    await MilestonesTable.insert(db, {
        'addiction_id': addiction1Id,
        'title': '1 Week Clean', 
        'target_value': 7,
        'achieved_at': start1.add(const Duration(days: 7)).toIso8601String(),
        'created_at': start1.toIso8601String(),
    });

    // Current pending milestone (30 Days)
    await MilestonesTable.insert(db, {
        'addiction_id': addiction1Id,
        'title': '30 Days Clean', 
        'target_value': 30, // Target is 30 days from creation
        'created_at': start1.toIso8601String(), // Created at start
        // Current day is 30, so it's ALMOST done or done depending on math
    });
    
    // 6. Set active addiction in preferences
    await _settingsHelper.saveCurrentAddictionId(addiction1Id);
    
    // 7. Create sample community posts
    await _seedCommunityPosts(db, userId);
    
    print('Seed complete!');
  }

  Future<void> _seedCommunityPosts(db, String userId) async {
    // Create some sample posts to demonstrate the community feature
    final posts = [
      {
        'user_id': userId,
        'title': 'My Journey',
        'content': 'Just hit my 30-day milestone! It\'s been tough, but this community has been a huge help. Thank you all for the support.',
        'visibility': 'public',
        'comment_count': 5,
        'reaction_count': 42,
        'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'user_id': userId,
        'title': 'Tips',
        'content': 'Does anyone have tips for dealing with cravings in social situations? I find weekends particularly challenging.',
        'visibility': 'public',
        'comment_count': 12,
        'reaction_count': 28,
        'created_at': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      },
      {
        'user_id': userId,
        'title': 'Motivation',
        'content': 'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today.',
        'visibility': 'public',
        'comment_count': 8,
        'reaction_count': 67,
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];

    for (final post in posts) {
      await PostsTable.insert(db, post);
    }
  }
}
