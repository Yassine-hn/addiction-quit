// sobriety_repository_abstract.dart

/// Repository for sobriety counter
abstract class SobrietyRepository {
  Future<Map<String, String>> getSobrietyTime({String? userId, int? addictionId});
  Future<bool> resetCounter({String? userId, int? addictionId});
}

