// repositories/progress_repository.dart
import '../models/progress_data.dart';

abstract class ProgressRepository {
  /// Get milestone progress (percentage, target, achieved)
  Future<Map<String, dynamic>> getMilestoneProgress(int addictionId);

  /// Get daily survey history for the grid
  Future<List<Map<String, dynamic>>> getDailySurveyHistory(
    int addictionId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get streak history for the chart
  Future<List<int>> getStreakHistory(int addictionId, int days);

  /// Get all active addictions for the user
  Future<List<Map<String, dynamic>>> getAllAddictions(int userId);
}
