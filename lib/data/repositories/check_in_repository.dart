// check_in_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/daily_surveys_table.dart';
import '../databases/tables/addictions_table.dart';
import 'user_repository_abstract.dart';
import 'user_repository.dart';
import 'check_in_repository_abstract.dart';
import 'milestone_repository.dart';

/// Implementation of CheckInRepository
class CheckInRepositoryImpl implements CheckInRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final UserRepository _userRepository = UserRepositoryImpl();
  final MilestoneRepository _milestoneRepository = MilestoneRepositoryImpl();

  /// Map mood labels to database values
  String _mapMoodToDbValue(String mood) {
    final moodMap = {
      'Awful': 'bad',
      'Sad': 'bad',
      'Okay': 'neutral',
      'Good': 'good',
    };
    return moodMap[mood] ?? 'neutral';
  }

  /// Get the primary active addiction for a user
  Future<Map<String, dynamic>?> _getPrimaryAddiction(int userId) async {
    try {
      final db = await _dbHelper.database;
      final addictions = await AddictionsTable.getActiveByUserId(db, userId);
      return addictions.isNotEmpty ? addictions.first : null;
    } catch (e) {
      print('Error getting primary addiction: $e');
      return null;
    }
  }

  /// Get current date in YYYY-MM-DD format
  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Submit daily check-in
  @override
  Future<bool> submitCheckIn({
    required String mood,
    required double cravingLevel,
    required String journalEntry,
    required bool slipped,
    required int slipAmount,
    int? userId,
    int? addictionId,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Get user ID if not provided
      userId ??= await _userRepository.getCurrentUserId();

      if (userId == null) {
        print('Error: No user ID available for check-in');
        return false;
      }

      // Get addiction ID if not provided
      if (addictionId == null) {
        final addiction = await _getPrimaryAddiction(userId);
        addictionId = addiction?['id'] as int?;
      }

      if (addictionId == null) {
        print('Error: No active addiction found for check-in');
        return false;
      }

      final today = _getCurrentDate();
      final dbMood = _mapMoodToDbValue(mood);

      // Convert craving level (0.0-1.0) to urge level (0-10)
      final urgeLevel = (cravingLevel * 10).round();

      // Check if check-in already exists for today
      final existingCheckIn = await DailySurveysTable.getByDate(
        db,
        addictionId,
        today,
      );

      final normalizedSlipAmount = slipped ? (slipAmount <= 0 ? 1 : slipAmount) : 0;

      final checkInData = {
        'addiction_id': addictionId,
        'date': today,
        'mood': dbMood,
        'urge_level': urgeLevel,
        'note': journalEntry.isNotEmpty ? journalEntry : null,
        'slipped': slipped ? 1 : 0,
        'slip_amount': normalizedSlipAmount,
        'created_at': DateTime.now().toIso8601String(),
      };

      if (existingCheckIn != null) {
        // Update existing check-in
        final id = existingCheckIn['id'] as int;
        await DailySurveysTable.update(db, id, checkInData);
      } else {
        // Create new check-in
        await DailySurveysTable.insert(db, checkInData);
      }

      // If slipped, increment slip counter and reset streak
      if (slipped) {
        await AddictionsTable.recordSlip(
          db,
          addictionId,
          amount: normalizedSlipAmount,
        );
        // Reset milestone on slip
        await _milestoneRepository.resetMilestoneOnSlip(addictionId);
      }

      return true;
    } catch (e) {
      print('Error submitting check-in: $e');
      return false;
    }
  }

  /// Get today's check-in if it exists
  @override
  Future<Map<String, dynamic>?> getTodayCheckIn({
    int? userId,
    int? addictionId,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Get user ID if not provided
      userId ??= await _userRepository.getCurrentUserId();

      if (userId == null) {
        return null;
      }

      // Get addiction ID if not provided
      if (addictionId == null) {
        final addiction = await _getPrimaryAddiction(userId);
        addictionId = addiction?['id'] as int?;
      }

      if (addictionId == null) {
        return null;
      }

      final today = _getCurrentDate();
      return await DailySurveysTable.getByDate(db, addictionId, today);
    } catch (e) {
      print('Error getting today check-in: $e');
      return null;
    }
  }

  /// Check if user has already checked in today
  @override
  Future<bool> hasCheckedInToday({int? userId, int? addictionId}) async {
    final checkIn = await getTodayCheckIn(
      userId: userId,
      addictionId: addictionId,
    );
    return checkIn != null;
  }
}
