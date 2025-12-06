// savings_repository_abstract.dart

/// Repository for savings (time saved and money saved)
abstract class SavingsRepository {
  Future<Map<String, dynamic>> getSavings({int? userId, int? addictionId});
  Future<int> getStreak({int? userId, int? addictionId});
  Future<String> getTimeSaved({int? userId, int? addictionId});
  Future<String?> getMoneySaved({int? userId, int? addictionId});
}

