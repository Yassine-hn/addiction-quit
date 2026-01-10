import '../../data/storage/token_storage.dart';

class SyncService {
  SyncService();

  /// Sync user profile updates (name, bio, avatar_url, language, etc.)
  /// Call this when user updates their profile settings in app
  Future<void> syncUserProfile() async {
    try {
      if (!await TokenStorage.isLoggedIn()) {
        print('User not authenticated. Skipping user profile sync.');
        return;
      }

      print('Syncing user profile updates...');
      // TODO: Implement if cloud endpoints for user profile updates are created
      // For now, profile updates are handled in-app and saved locally
    } catch (e) {
      print('Error syncing user profile: $e');
    }
  }

  /// DEPRECATED: Full sync is no longer used in signup flow
  /// Signup now only syncs user data via SignupSyncService
  @deprecated
  Future<void> syncAll() async {
    print('⚠️ syncAll() is deprecated. Signup only uses SignupSyncService.');
  }
}
