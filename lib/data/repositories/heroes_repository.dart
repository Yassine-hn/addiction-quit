import '../../data/databases/db_helper.dart';
import '../../data/databases/tables/heroes_table.dart';

class HeroesRepository {
  /// Get weekly heroes (leaderboard)
  Future<List<Map<String, dynamic>>> getWeeklyHeroes() async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getWeeklyHeroes(db);
  }

  /// Get monthly heroes (leaderboard)
  Future<List<Map<String, dynamic>>> getMonthlyHeroes() async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getMonthlyHeroes(db);
  }

  /// Get leaderboard for a specific period
  Future<List<Map<String, dynamic>>> getLeaderboard(
    String periodType, {
    int? limit,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getLeaderboard(db, periodType, limit: limit);
  }

  /// Get user's hero entries
  Future<List<Map<String, dynamic>>> getUserHeroes(int userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getByUserId(db, userId, limit: limit);
  }

  /// Get user's rank in a period
  Future<int?> getUserRank(int userId, String periodType) async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getUserRank(db, userId, periodType);
  }

  /// Add or update hero entry
  Future<int> updateHeroEntry({
    required int userId,
    required String periodType,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int score,
    required int rank,
    String? metricSource,
    String? heroBadgeUrl,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.insert(db, {
      'user_id': userId,
      'period_type': periodType,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
      'score': score,
      'rank': rank,
      'metric_source': metricSource,
      'hero_badge_url': heroBadgeUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get heroes created after a timestamp (for sync)
  Future<List<Map<String, dynamic>>> getHeroesForSync(String lastSyncTime) async {
    final db = await DatabaseHelper.instance.database;
    return await HeroesTable.getCreatedAfter(db, lastSyncTime);
  }
}
