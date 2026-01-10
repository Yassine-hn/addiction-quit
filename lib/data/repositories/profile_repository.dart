// profile_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/users_table.dart';
import '../databases/tables/addictions_table.dart';
import '../databases/tables/milestones_table.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

// Abstract class defining the contract
abstract class ProfileRepository {
  Future<Map<String, String>> fetchUserProfile();
  Future<List<Map<String, dynamic>>> fetchUserAchievements();
  Future<List<Map<String, dynamic>>> fetchUserJourneys();
  Future<bool> updateProfile({required String name, required String tagline});
  Future<bool> addAchievement({
    required String icon,
    required String title,
    required String date,
  });
  Future<bool> addJourney({
    required String icon,
    required String title,
    required String subtitle,
    required String days,
  });
  Future<bool> deleteJourney(String journeyId);
}

// Implementation with database
class ProfileRepositoryImpl implements ProfileRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<Map<String, String>> fetchUserProfile() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        return {'name': 'User', 'tagline': 'Your journey to a better you'};
      }

      final db = await _dbHelper.database;
      final user = await UsersTable.getById(db, userId);

      if (user == null) {
        return {'name': 'User', 'tagline': 'Your journey to a better you'};
      }

      return {
        'name': user['name'] as String? ?? 'User',
        'tagline': user['bio'] as String? ?? 'Your journey to a better you',
      };
    } catch (e) {
      print('Error fetching user profile: $e');
      return {'name': 'User', 'tagline': 'Your journey to a better you'};
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserAchievements() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        return [];
      }

      final db = await _dbHelper.database;
      final addictions = await AddictionsTable.getByUserId(db, userId);

      List<Map<String, dynamic>> achievements = [];

      for (var addiction in addictions) {
        final addictionId = addiction['id'] as int;
        final achievedMilestones = await MilestonesTable.getAchieved(
          db,
          addictionId,
        );

        for (var milestone in achievedMilestones) {
          final achievedAt = milestone['achieved_at'] as String?;
          if (achievedAt != null) {
            try {
              final date = DateTime.parse(achievedAt);
              final months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              // Store date parts separately for localization in UI
              final dateParts = {
                'month': months[date.month - 1],
                'day': date.day,
                'year': date.year,
              };

              achievements.add({
                'icon': 'star',
                'title': milestone['title'] as String? ?? 'Milestone',
                'date': dateParts, // Store as map for localization
              });
            } catch (e) {
              // Skip invalid dates
            }
          }
        }
      }

      // Sort by date (most recent first)
      achievements.sort((a, b) {
        // Simple string comparison for date
        return (b['date'] as String).compareTo(a['date'] as String);
      });

      return achievements;
    } catch (e) {
      print('Error fetching achievements: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserJourneys() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        return [];
      }

      final db = await _dbHelper.database;
      final addictions = await AddictionsTable.getByUserId(db, userId);

      List<Map<String, dynamic>> journeys = [];

      for (var addiction in addictions) {
        final type = addiction['addiction_type'] as String? ?? 'Unknown';
        final startDateStr = addiction['start_date'] as String?;
        final streak = addiction['streak'] as int? ?? 0;

        if (startDateStr != null) {
          try {
            final startDate = DateTime.parse(startDateStr);
            final now = DateTime.now();
            final days = now.difference(startDate).inDays;

            // Map addiction type to icon
            String icon = 'star';
            if (type.toLowerCase().contains('coffee') ||
                type.toLowerCase().contains('caffeine')) {
              icon = 'coffee';
            } else if (type.toLowerCase().contains('phone') ||
                type.toLowerCase().contains('social')) {
              icon = 'phone';
            } else if (type.toLowerCase().contains('smoke') ||
                type.toLowerCase().contains('vape')) {
              icon = 'smoke';
            }

            // Note: Localization for subtitle and days will be done in UI layer
            journeys.add({
              'icon': icon,
              'title': type,
              'subtitle': streak, // Pass streak as int for localization
              'days': days, // Pass days as int for localization
              'addiction_id':
                  addiction['id'], // Include addiction ID for switching
            });
          } catch (e) {
            // Skip invalid dates
          }
        }
      }

      return journeys;
    } catch (e) {
      print('Error fetching journeys: $e');
      return [];
    }
  }

  @override
  Future<bool> updateProfile({
    required String name,
    required String tagline,
  }) async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        return false;
      }

      final db = await _dbHelper.database;
      await UsersTable.update(db, userId, {'name': name, 'bio': tagline});

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  @override
  Future<bool> addAchievement({
    required String icon,
    required String title,
    required String date,
  }) async {
    // Placeholder for future implementation
    return true;
  }

  @override
  Future<bool> addJourney({
    required String icon,
    required String title,
    required String subtitle,
    required String days,
  }) async {
    // Placeholder for future implementation
    return true;
  }

  @override
  Future<bool> deleteJourney(String journeyId) async {
    // Placeholder for future implementation
    return true;
  }
}
