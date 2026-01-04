// sobriety_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/addictions_table.dart';
import 'user_repository_abstract.dart';
import 'user_repository.dart';
import 'sobriety_repository_abstract.dart';

/// Implementation of SobrietyRepository
class SobrietyRepositoryImpl implements SobrietyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final UserRepository _userRepository = UserRepositoryImpl();

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

  /// Calculate time difference from a start date
  Map<String, String> _calculateTimeDifference(DateTime startDate) {
    final now = DateTime.now();
    final difference = now.difference(startDate);

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    return {
      'days': days.toString(),
      'hours': hours.toString(),
      'minutes': minutes.toString(),
    };
  }

  /// Get sobriety time for the user's primary addiction
  @override
  Future<Map<String, String>> getSobrietyTime({
    int? userId,
    int? addictionId,
  }) async {
    try {
      final db = await _dbHelper.database;

      // Get user ID if not provided
      userId ??= await _userRepository.getCurrentUserId();

      if (userId == null) {
        return {'days': '0', 'hours': '0', 'minutes': '0'};
      }

      Map<String, dynamic>? addiction;

      if (addictionId != null) {
        addiction = await AddictionsTable.getById(db, addictionId);
      } else {
        addiction = await _getPrimaryAddiction(userId);
      }

      if (addiction == null) {
        return {'days': '0', 'hours': '0', 'minutes': '0'};
      }

      // Get counter_start_at or start_date
      final startDateStr =
          addiction['counter_start_at'] as String? ??
          addiction['start_date'] as String?;

      if (startDateStr == null) {
        return {'days': '0', 'hours': '0', 'minutes': '0'};
      }

      final startDate = DateTime.parse(startDateStr);
      return _calculateTimeDifference(startDate);
    } catch (e) {
      print('Error getting sobriety time: $e');
      return {'days': '0', 'hours': '0', 'minutes': '0'};
    }
  }
}
