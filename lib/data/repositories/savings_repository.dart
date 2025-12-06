// savings_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/addictions_table.dart';
import 'user_repository_abstract.dart';
import 'user_repository.dart';
import 'savings_repository_abstract.dart';

/// Implementation of SavingsRepository
class SavingsRepositoryImpl implements SavingsRepository {
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

  /// Format time saved in a human-readable format
  String _formatTimeSaved(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours h';
      }
      return '$hours h $remainingMinutes min';
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return '$days d';
      }
      return '$days d $remainingHours h';
    }
  }

  /// Format money saved
  String _formatMoneySaved(double totalSaved) {
    if (totalSaved >= 1000) {
      return '\$${(totalSaved / 1000).toStringAsFixed(1)}k';
    }
    return '\$${totalSaved.toStringAsFixed(0)}';
  }

  /// Get streak for the user's primary addiction
  @override
  Future<int> getStreak({int? userId, int? addictionId}) async {
    try {
      final db = await _dbHelper.database;
      
      // Get user ID if not provided
      if (userId == null) {
        userId = await _userRepository.getCurrentUserId();
      }
      
      if (userId == null) {
        return 0;
      }

      Map<String, dynamic>? addiction;
      
      if (addictionId != null) {
        addiction = await AddictionsTable.getById(db, addictionId);
      } else {
        addiction = await _getPrimaryAddiction(userId);
      }

      if (addiction == null) {
        return 0;
      }

      return addiction['streak'] as int? ?? 0;
    } catch (e) {
      print('Error getting streak: $e');
      return 0;
    }
  }

  /// Get time saved for the user's primary addiction
  @override
  Future<String> getTimeSaved({int? userId, int? addictionId}) async {
    try {
      final db = await _dbHelper.database;
      
      // Get user ID if not provided
      if (userId == null) {
        userId = await _userRepository.getCurrentUserId();
      }
      
      if (userId == null) {
        return '0 min';
      }

      Map<String, dynamic>? addiction;
      
      if (addictionId != null) {
        addiction = await AddictionsTable.getById(db, addictionId);
      } else {
        addiction = await _getPrimaryAddiction(userId);
      }

      if (addiction == null) {
        return '0 min';
      }

      // Get time_saved from database (in minutes)
      final timeSavedMinutes = addiction['time_saved'] as int? ?? 0;
      
      // If time_saved is 0, calculate from start date
      if (timeSavedMinutes == 0) {
        final startDateStr = addiction['counter_start_at'] as String? ?? 
                            addiction['start_date'] as String?;
        
        if (startDateStr != null) {
          try {
            final startDate = DateTime.parse(startDateStr);
            final now = DateTime.now();
            final difference = now.difference(startDate);
            final calculatedMinutes = difference.inDays * 1440 + 
                                     difference.inHours % 24 * 60 + 
                                     difference.inMinutes % 60;
            
            // Update the database with calculated time
            final addictionId = addiction['id'] as int;
            await AddictionsTable.updateTimeSavedPerDay(db, addictionId, calculatedMinutes);
            
            return _formatTimeSaved(calculatedMinutes);
          } catch (e) {
            print('Error calculating time saved: $e');
          }
        }
      }
      
      return _formatTimeSaved(timeSavedMinutes);
    } catch (e) {
      print('Error getting time saved: $e');
      return '0 min';
    }
  }

  /// Get money saved for the user's primary addiction
  /// Returns null if the addiction doesn't save money (money_saved_per_day is null)
  @override
  Future<String?> getMoneySaved({int? userId, int? addictionId}) async {
    try {
      final db = await _dbHelper.database;
      
      // Get user ID if not provided
      if (userId == null) {
        userId = await _userRepository.getCurrentUserId();
      }
      
      if (userId == null) {
        return null;
      }

      Map<String, dynamic>? addiction;
      
      if (addictionId != null) {
        addiction = await AddictionsTable.getById(db, addictionId);
      } else {
        addiction = await _getPrimaryAddiction(userId);
      }

      if (addiction == null) {
        return null;
      }

      // Check if money_saved_per_day is null (addiction doesn't save money)
      final moneySavedPerDay = addiction['money_saved_per_day'] as double?;
      
      if (moneySavedPerDay == null) {
        return null; // This addiction doesn't save money
      }

      // Calculate total money saved
      final startDateStr = addiction['counter_start_at'] as String? ?? 
                          addiction['start_date'] as String?;
      
      if (startDateStr == null) {
        return '\$0';
      }

      try {
        final startDate = DateTime.parse(startDateStr);
        final now = DateTime.now();
        final days = now.difference(startDate).inDays;
        final totalSaved = days * moneySavedPerDay;
        
        return _formatMoneySaved(totalSaved);
      } catch (e) {
        print('Error calculating money saved: $e');
        return '\$0';
      }
    } catch (e) {
      print('Error getting money saved: $e');
      return null;
    }
  }

  /// Get all savings data (streak, time saved, money saved)
  @override
  Future<Map<String, dynamic>> getSavings({int? userId, int? addictionId}) async {
    final streak = await getStreak(userId: userId, addictionId: addictionId);
    final timeSaved = await getTimeSaved(userId: userId, addictionId: addictionId);
    final moneySaved = await getMoneySaved(userId: userId, addictionId: addictionId);

    return {
      'streak': streak,
      'timeSaved': timeSaved,
      'moneySaved': moneySaved, // Can be null if addiction doesn't save money
    };
  }
}

