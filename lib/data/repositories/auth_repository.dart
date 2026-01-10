import '../../api/api_service.dart';
import '../storage/token_storage.dart';
import '../../logic/services/signup_sync_service.dart';

/// Abstract interface for authentication repository
abstract class AuthRepository {
  Future<AuthResult> checkAuthStatus();
  Future<AuthResult> register({
    required String email,
    required String password,
  });
  Future<AuthResult> login({
    required String email,
    required String password,
  });
  Future<AuthResult> logout();
}

/// Implementation of authentication repository
/// Acts as a single source of truth for auth data
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SignupSyncService _signupSyncService = SignupSyncService();

  AuthRepositoryImpl(this._apiService);

  @override

  /// Check if user is currently authenticated
  Future<AuthResult> checkAuthStatus() async {
    try {
      final isLoggedIn = await TokenStorage.isLoggedIn();
      
      if (isLoggedIn) {
        final userId = await TokenStorage.getUserId();
        final email = await TokenStorage.getUserEmail();
        final name = await TokenStorage.getUserName();
        
        if (userId != null && email != null && name != null) {
          return AuthResult.success(
            user: UserData(
              userId: userId,
              email: email,
              name: name,
            ),
          );
        }
      }
      
      return AuthResult.unauthenticated();
    } catch (e) {
      return AuthResult.failure('Failed to check auth status: $e');
    }
  }

  @override
  /// Register a new user
  Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    try {
      // Preflight: quick health check to avoid long timeouts and give clearer feedback
      final isHealthy = await _apiService.healthCheck();
      if (!isHealthy) {
        return AuthResult.failure(
          'Server unreachable. Please verify your network or API base URL: ${ApiService.baseUrl}',
        );
      }

      // Step 1: Get local user data
      final localUserData = await _signupSyncService.getLocalUserData();
      
      if (localUserData == null) {
        return AuthResult.failure('No local user data found. Please complete onboarding first.');
      }
      
      final oldLocalUserId = await _signupSyncService.getCurrentLocalUserId();
      
      if (oldLocalUserId == null) {
        return AuthResult.failure('Could not retrieve local user ID.');
      }
      
      // Step 2: Call API with email, password, and full user data
      final response = await _apiService.register(
        email: email,
        password: password,
        userData: localUserData,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final user = data['user'] as Map<String, dynamic>;
        final accessToken = data['access_token'] as String;
        final refreshToken = data['refresh_token'] as String;

        // Step 3: Save tokens to secure storage
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        
        // Step 4: Update local database with cloud user data
        await _signupSyncService.updateLocalAfterSignup(
          oldLocalUserId: oldLocalUserId,
          cloudUserData: user,
        );
        
        // Step 5: Save user info to secure storage (with new cloud UUID)
        await TokenStorage.saveUserInfo(
          userId: user['id'].toString(),
          email: user['email'],
          name: user['name'],
        );

        return AuthResult.success(
          user: UserData(
            userId: user['id'].toString(),
            email: user['email'],
            name: user['name'],
          ),
        );
      } else {
        return AuthResult.failure(response.message);
      }
    } catch (e) {
      return AuthResult.failure('Registration failed: $e');
    }
  }

  @override
  /// Login an existing user
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final user = data['user'] as Map<String, dynamic>;
        final accessToken = data['access_token'] as String;
        final refreshToken = data['refresh_token'] as String;

        // Save tokens and user info to secure storage
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await TokenStorage.saveUserInfo(
          userId: user['id'].toString(),
          email: user['email'],
          name: user['name'],
        );

        return AuthResult.success(
          user: UserData(
            userId: user['id'].toString(),
            email: user['email'],
            name: user['name'],
            score: user['score'] ?? 0,
          ),
        );
      } else {
        return AuthResult.failure(response.message);
      }
    } catch (e) {
      return AuthResult.failure('Login failed: $e');
    }
  }

  @override
  /// Logout current user
  Future<AuthResult> logout() async {
    try {
      await _apiService.logout();
      await TokenStorage.clearAll();
      return AuthResult.unauthenticated();
    } catch (e) {
      // Even if API call fails, clear local storage
      await TokenStorage.clearAll();
      return AuthResult.unauthenticated();
    }
  }
}

/// Domain model for user data
class UserData {
  final String userId;
  final String email;
  final String name;
  final int score;

  UserData({
    required this.userId,
    required this.email,
    required this.name,
    this.score = 0,
  });
}

/// Result wrapper for auth operations
class AuthResult {
  final bool isSuccess;
  final bool isAuthenticated;
  final UserData? user;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    required this.isAuthenticated,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success({required UserData user}) {
    return AuthResult._(
      isSuccess: true,
      isAuthenticated: true,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(
      isSuccess: false,
      isAuthenticated: false,
      errorMessage: message,
    );
  }

  factory AuthResult.unauthenticated() {
    return AuthResult._(
      isSuccess: true,
      isAuthenticated: false,
    );
  }
}
