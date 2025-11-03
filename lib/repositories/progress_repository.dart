// repositories/progress_repository.dart
import '../models/progress_data.dart';


abstract class ProgressRepository {
  Future<ProgressData> getProgressData();
  Future<WeeklyProgress> getWeeklyProgress();
  Future<List<Goal>> getAvailableGoals();
  Future<void> selectGoal(String goalTitle);
}