// milestone_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/milestones_table.dart';
import '../databases/tables/users_table.dart';

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

  /// Reset milestone on slip (restart created_at)
  Future<void> resetMilestoneOnSlip(int addictionId);

  /// Claim reward and mark milestone as achieved
  Future<bool> claimMilestoneReward(int userId, int milestoneId);
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

  @override
  Future<void> resetMilestoneOnSlip(int addictionId) async {
    try {
      final db = await _dbHelper.database;
      final pendingMilestones = await MilestonesTable.getPending(
        db,
        addictionId,
      );

      // Reset all pending milestones created_at to now
      for (var milestone in pendingMilestones) {
        final milestoneId = milestone['id'] as int;
        await MilestonesTable.resetCreatedAt(db, milestoneId);
      }
    } catch (e) {
      print('Error resetting milestone on slip: $e');
    }
  }

  @override
  Future<bool> claimMilestoneReward(int userId, int milestoneId) async {
    try {
      final db = await _dbHelper.database;
      final milestone = await MilestonesTable.getById(db, milestoneId);

      if (milestone == null || milestone['achieved_at'] != null) {
        return false; // Already achieved or doesn't exist
      }

      // Get reward points (default 0)
      final rewardPoints = milestone['reward_points'] as int? ?? 0;

      // Mark as achieved
      await MilestonesTable.markAsAchieved(db, milestoneId);

      // Update user score
      final user = await UsersTable.getById(db, userId);
      if (user != null) {
        final currentScore = user['score'] as int? ?? 0;
        await UsersTable.updateScore(db, userId, currentScore + rewardPoints);
      }

      return true;
    } catch (e) {
      print('Error claiming milestone reward: $e');
      return false;
    }
  }
}