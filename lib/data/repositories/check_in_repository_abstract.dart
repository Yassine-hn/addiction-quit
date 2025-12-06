// check_in_repository_abstract.dart

/// Repository for daily check-ins
abstract class CheckInRepository {
  Future<bool> submitCheckIn({
    required String mood,
    required double cravingLevel,
    required String journalEntry,
    int? userId,
    int? addictionId,
  });
  
  Future<Map<String, dynamic>?> getTodayCheckIn({
    int? userId,
    int? addictionId,
  });
  
  Future<bool> hasCheckedInToday({
    int? userId,
    int? addictionId,
  });
}

