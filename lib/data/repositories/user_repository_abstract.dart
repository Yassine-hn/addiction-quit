// user_repository_abstract.dart

/// Repository for user-related operations
abstract class UserRepository {
  Future<Map<String, dynamic>?> getCurrentUser();
  Future<String?> getUserName();
  Future<int?> getCurrentUserId();
}

