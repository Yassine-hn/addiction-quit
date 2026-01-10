// savings_repository_abstract.dart

/// Repository for savings (time saved and money saved)
abstract class SavingsRepository {
  Future<Map<String, dynamic>> getSavings({Object? userId, int? addictionId});
  Future<int> getStreak({Object? userId, int? addictionId});
  Future<String> getTimeSaved({Object? userId, int? addictionId});
  Future<String?> getMoneySaved({Object? userId, int? addictionId});
}

