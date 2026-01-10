// check_in_repository_abstract.dart

/// Repository for daily check-ins
abstract class CheckInRepository {
  Future<bool> submitCheckIn({
    required String mood,
    required double cravingLevel,
    required String journalEntry,
    required bool slipped,
    required int slipAmount,
    String? userId,
    int? addictionId,
  });
  
  Future<Map<String, dynamic>?> getTodayCheckIn({
    String? userId,
    int? addictionId,
  });
  
  Future<bool> hasCheckedInToday({
    String? userId,
    int? addictionId,
  });
}

