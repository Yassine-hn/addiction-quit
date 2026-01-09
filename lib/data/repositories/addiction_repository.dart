// addiction_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/addictions_table.dart';
import '../databases/tables/daily_surveys_table.dart';

abstract class AddictionRepository {
  /// Get streak history for last 30 days
  Future<List<Map<String, dynamic>>> getStreakHistory(
    Object userId,
    int addictionId,
    int days,
  );

  /// Get all user's addictions
  Future<List<Map<String, dynamic>>> getAllUserAddictions(Object userId);
}

class AddictionRepositoryImpl implements AddictionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Map<String, dynamic>>> getStreakHistory(
    Object userId,
    int addictionId,
    int days,
  ) async {
    try {
      final db = await _dbHelper.database;
      final addiction = await AddictionsTable.getById(db, addictionId);

      if (addiction == null) {
        return List.generate(
          days,
          (index) => {
            'date': DateTime.now()
                .subtract(Duration(days: days - 1 - index))
                .toIso8601String()
                .split('T')[0],
            'streak_value': 0,
          },
        );
      }

      // Get start date
      final startStr =
          addiction['counter_start_at'] as String? ??
          addiction['start_date'] as String;
      final startDate = DateTime.parse(startStr);

      // Get all surveys
      final surveys = await DailySurveysTable.getByAddictionId(db, addictionId);
      final surveyMap = {
        for (var s in surveys) (s['date'] as String).substring(0, 10): s,
      };

      // Calculate streak day by day
      List<Map<String, dynamic>> history = [];
      int currentStreak = 0;
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);

      DateTime iterDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      if (iterDate.isAfter(normalizedToday)) {
        return List.generate(
          days,
          (index) => {
            'date': DateTime.now()
                .subtract(Duration(days: days - 1 - index))
                .toIso8601String()
                .split('T')[0],
            'streak_value': 0,
          },
        );
      }

      Map<String, int> streakHistoryMap = {};

      while (!iterDate.isAfter(normalizedToday)) {
        final dateKey = iterDate.toIso8601String().substring(0, 10);
        final survey = surveyMap[dateKey];

        bool slipped = false;
        if (survey != null) {
          slipped = (survey['slipped'] as int? ?? 0) == 1;
        }

        if (slipped) {
          currentStreak = 0;
        } else {
          currentStreak++;
        }

        streakHistoryMap[dateKey] = currentStreak;
        iterDate = iterDate.add(const Duration(days: 1));
      }

      // Extract last 'days' points
      for (int i = days - 1; i >= 0; i--) {
        final d = normalizedToday.subtract(Duration(days: i));
        final key = d.toIso8601String().substring(0, 10);
        history.add({'date': key, 'streak_value': streakHistoryMap[key] ?? 0});
      }

      return history;
    } catch (e) {
      print('Error getting streak history: $e');
      return List.generate(
        days,
        (index) => {
          'date': DateTime.now()
              .subtract(Duration(days: days - 1 - index))
              .toIso8601String()
              .split('T')[0],
          'streak_value': 0,
        },
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUserAddictions(Object userId) async {
    try {
      final db = await _dbHelper.database;
      return await AddictionsTable.getByUserId(db, userId);
    } catch (e) {
      print('Error getting all user addictions: $e');
      return [];
    }
  }
}
