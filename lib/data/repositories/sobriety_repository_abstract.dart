// sobriety_repository_abstract.dart

/// Repository for sobriety counter
abstract class SobrietyRepository {
  Future<Map<String, String>> getSobrietyTime({int? userId, int? addictionId});

  Future<bool> resetCounter({int? userId, int? addictionId});
}

