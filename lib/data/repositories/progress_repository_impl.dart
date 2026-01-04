import 'progress_repository.dart';
import '../databases/db_helper.dart';
import '../databases/tables/addictions_table.dart';
import '../databases/tables/daily_surveys_table.dart';
import '../databases/tables/milestones_table.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<Map<String, dynamic>> getMilestoneProgress(int addictionId) async {
    final db = await _dbHelper.database;
    final milestones = await MilestonesTable.getPending(db, addictionId);

    if (milestones.isEmpty) {
      // Logic to find if there are any achieved ones, maybe return "All done" or null
      return {};
    }

    final currentMilestone = milestones.first;
    final createdAtStr = currentMilestone['created_at'] as String;
    final targetValue = currentMilestone['target_value'] as int;
    final createdAt = DateTime.parse(createdAtStr);
    final now = DateTime.now();

    // Calculate days passed since creation
    final daysPassed = now.difference(createdAt).inDays;

    // Percentage: capped at 100% (1.0)
    double percentage = 0.0;
    if (targetValue > 0) {
      percentage = (daysPassed / targetValue).clamp(0.0, 1.0);
    }

    return {
      'milestone': currentMilestone,
      'percentage': percentage,
      'days_passed': daysPassed,
      'target_days': targetValue,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getDailySurveyHistory(
    int addictionId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    // Format dates for query
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];

    return await DailySurveysTable.getByDateRange(
      db,
      addictionId,
      startStr,
      endStr,
    );
  }

  @override
  Future<List<int>> getStreakHistory(int addictionId, int days) async {
    final db = await _dbHelper.database;
    final addiction = await AddictionsTable.getById(db, addictionId);
    if (addiction == null) return List.filled(days, 0);

    // Get start date of the addiction counter
    final startStr =
        addiction['counter_start_at'] as String? ??
        addiction['start_date'] as String;
    final startDate = DateTime.parse(startStr);

    // We need to reconstruct streak from the beginning to be accurate
    // But for performance, if the addiction is old, this might be slow.
    // However, given it's local DB, it should be fine for a single user.

    // Fetch all surveys (or at least slips)
    // To be accurate about "missed days breaks streak", we need to know every day status.
    // If 'streak' implies "days without slip", then missing a survey might not break it
    // depending on the rule.
    // Standard rule: Streak is days since last slip.
    // User prompt checking: "daily survey table contains slip bool attribute... if there is no record... he didn't do the survey".
    // AND "make it green if... didn't slip".
    // AND "progress streak... values can got by a repository... streak is an attribute in the addction table".

    // IF the user simply wants the stored streak value, that's just one number.
    // BUT they asked for a CHART. A chart needs history.
    // AND they said "values can got by a repository ... streak is an attribute".
    // This might mean: Just assume the streak increased by 1 each day until a slip reset it?
    // I will implement the reconstruction logic as it's the only way to get a CHART.

    // Logic: calculate streak day by day from (Today - 30 days) to Today.
    // To know the streak at (Today - 30), we strictly need to calculate from the very start.

    final surveys = await DailySurveysTable.getByAddictionId(
      db,
      addictionId,
    ); // Ordered by date DESC
    // Map surveys by date for O(1) lookup
    final surveyMap = {
      for (var s in surveys) (s['date'] as String).substring(0, 10): s,
    };

    List<int> history = [];
    final today = DateTime.now();

    // Optimization: If we trust the CURRENT streak in DB, we can work specific logic?
    // No, working backwards is hard because we don't know *when* the streak started without traversing.
    // Working forward from start is safest.

    int currentStreak = 0;
    // Iterate from start date to today
    // If start date is in future (impossible?) or very recent.

    // Correct loop:
    // We only need the last 'days' (e.g. 30) data points.
    // But we need the accumulator value.

    // Start iterating from the addiction start date
    DateTime iterDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    // Normalize today
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // If start date is after today (sanity check), return 0s
    if (iterDate.isAfter(normalizedToday)) return List.filled(days, 0);

    // Map of Date -> Streak Value
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
        // If no slip, streak increases.
        // Note: Does missing a survey break streak?
        // User said: "make it green if ... didn't slip, red if ... slipped, empty if ... didn't slip".
        // Usually, streak counts days sober/clean. So even if no survey, if no slip reported, it counts?
        // OR does it only count if you check in?
        // User rule: "if there is no record... that means he didn't do the survey".
        // The Prompt for "Progress" (Grid) is distinct from "Streak" (Chart).
        // For Sobriety apps, usually Streak = Days since last slip.
        // So I will increment streak every day unless there is a recorded slip.
        currentStreak++;
      }

      streakHistoryMap[dateKey] = currentStreak;
      iterDate = iterDate.add(const Duration(days: 1));
    }

    // Now extract the last 'days' points
    for (int i = days - 1; i >= 0; i--) {
      final d = normalizedToday.subtract(Duration(days: i));
      final key = d.toIso8601String().substring(0, 10);
      history.add(streakHistoryMap[key] ?? 0); // 0 if date was before start
    }

    return history;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllAddictions(int userId) async {
    final db = await _dbHelper.database;
    // We want all active ones to switch between
    // Or just all? User said "show all the user's addictions"
    return await AddictionsTable.getByUserId(db, userId);
  }
}
