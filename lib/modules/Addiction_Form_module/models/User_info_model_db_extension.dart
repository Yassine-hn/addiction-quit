import 'User_Info_model.dart';

// In User_Info_model.dart, add these methods:

extension UserInfoModelDBExtension on UserInfoModel {
  /// Convert UserInfoModel to a users table row
  Map<String, dynamic> toUsersTableRow() {
    return {
      'name': username,
      'created_at': DateTime.now().toIso8601String(),
      'score': 0, // Default score
      'is_active': 1,
    };
  }

  /// Convert UserInfoModel to an addictions table row
  Map<String, dynamic> toAddictionsTableRow(int userId) {
    // Calculate consumption per week
    final consumptionPerWeek =
        (consumptionDayPerWeek ?? 0) * (consumptionPerDay ?? 0);

    return {
      'user_id': userId,
      'addiction_type': addictionType,
      'start_date': startDate?.toIso8601String(),
      'counter_start_at': startDate?.toIso8601String(),
      'slips': 0,
      'goal_type': _getGoalType(),
      'daily_target': _calculateDailyTarget(),
      'streak': 0,
      'status': 'active',
      'note': 'Motivation: $mainMotivation\nImportance: $importanceForUser',
      'motivation': mainMotivation,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  /// Helper method to determine goal type
  String _getGoalType() {
    if (goals?.contains('Quit completely') == true) return 'quit';
    if (goals?.contains('Reduce consumption') == true) return 'reduce';
    return 'control';
  }

  /// Helper method to calculate daily target
  int? _calculateDailyTarget() {
    if (goals?.contains('Quit completely') == true) return 0;
    if (consumptionPerDay != null) {
      // Example: Reduce by 50% initially
      return (consumptionPerDay! * 0.5).ceil();
    }
    return null;
  }

  /// Convert money saved to string for storage
  String? get moneySavedPerDayString {
    if (moneySavedPerDay == null) return null;
    return '${moneySavedPerDay!['amount']} ${moneySavedPerDay!['currency']}';
  }
}
