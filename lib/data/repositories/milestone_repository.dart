// milestone_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/milestones_table.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

abstract class MilestoneRepository {
  /// Calculate milestone progress percentage
  /// Returns percentage (0.0 to 100.0) or -1 if no active milestone
  Future<double> calculateMilestoneProgress(int userId, int addictionId);

  /// Get current active milestone
  Future<Map<String, dynamic>?> getCurrentMilestone(int addictionId);

  /// Create a new milestone
  Future<int> createMilestone(int addictionId, int targetDays, String title);

  /// Check and mark completed milestones as achieved
  Future<void> checkAndMarkCompletedMilestones(int addictionId);
}

class MilestoneRepositoryImpl implements MilestoneRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<double> calculateMilestoneProgress(int userId, int addictionId) async {
    try {
      final db = await _dbHelper.database;
      final milestones = await MilestonesTable.getPending(db, addictionId);

      if (milestones.isEmpty) {
        return -1.0; // No active milestone
      }

      final currentMilestone = milestones.first;
      final createdAtStr = currentMilestone['created_at'] as String;
      final targetDays = currentMilestone['target_value'] as int;

      if (targetDays <= 0) {
        return 0.0;
      }

      final createdAt = DateTime.parse(createdAtStr);
      final now = DateTime.now();

      // Calculate days elapsed
      final daysElapsed = now.difference(createdAt).inDays;

      // Calculate percentage: (days_elapsed / target_days) × 100
      final percentage = (daysElapsed / targetDays) * 100.0;

      // Cap at 100%
      return percentage.clamp(0.0, 100.0);
    } catch (e) {
      print('Error calculating milestone progress: $e');
      return -1.0;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentMilestone(int addictionId) async {
    try {
      final db = await _dbHelper.database;
      final milestones = await MilestonesTable.getPending(db, addictionId);
      return milestones.isNotEmpty ? milestones.first : null;
    } catch (e) {
      print('Error getting current milestone: $e');
      return null;
    }
  }

  @override
  Future<int> createMilestone(
    int addictionId,
    int targetDays,
    String title,
  ) async {
    try {
      final db = await _dbHelper.database;
      final milestoneData = {
        'addiction_id': addictionId,
        'title': title,
        'description': 'Reach $targetDays days milestone',
        'target_value': targetDays,
        'type': 'milestone',
        'created_at': DateTime.now().toIso8601String(),
      };
      return await MilestonesTable.insert(db, milestoneData);
    } catch (e) {
      print('Error creating milestone: $e');
      rethrow;
    }
  }

  @override
  Future<void> checkAndMarkCompletedMilestones(int addictionId) async {
    try {
      final db = await _dbHelper.database;
      final pendingMilestones = await MilestonesTable.getPending(
        db,
        addictionId,
      );
      final now = DateTime.now();

      for (var milestone in pendingMilestones) {
        final createdAtStr = milestone['created_at'] as String;
        final targetDays = milestone['target_value'] as int;
        final createdAt = DateTime.parse(createdAtStr);
        final daysElapsed = now.difference(createdAt).inDays;

        // If milestone is completed (days elapsed >= target days)
        if (daysElapsed >= targetDays) {
          final milestoneId = milestone['id'] as int;
          await MilestonesTable.markAsAchieved(db, milestoneId);
        }
      }
    } catch (e) {
      print('Error checking completed milestones: $e');
    }
  }
}
