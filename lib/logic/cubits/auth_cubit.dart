import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import '../../data/storage/token_storage.dart';
import '../../logic/services/sync_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService;

  AuthCubit(this._apiService) : super(AuthInitial());

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    
    final isLoggedIn = await TokenStorage.isLoggedIn();
    if (isLoggedIn) {
      final userId = await TokenStorage.getUserId();
      final email = await TokenStorage.getUserEmail();
      final name = await TokenStorage.getUserName();
      
      if (userId != null && email != null && name != null) {
        // Trigger sync in background after auth check
        _triggerSync();
        
        emit(AuthAuthenticated(
          userId: userId,
          email: email,
          name: name,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Helper to trigger sync without blocking auth flow
  void _triggerSync() {
    final syncService = SyncService(_apiService);
    // Fire and forget: sync in background
    syncService.syncAll().catchError((e) {
      print('Background sync error: $e');
    });
  }

  // Register user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? dob,
  }) async {
    emit(AuthLoading());
    
    final response = await _apiService.register(
      name: name,
      email: email,
      password: password,
      dob: dob,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final user = data['user'] as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      // Save tokens and user info
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await TokenStorage.saveUserInfo(
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
      );

      emit(AuthAuthenticated(
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
      ));
      
      // Trigger sync in background after registration
      _triggerSync();
    } else {
      emit(AuthError(response.message));
      emit(AuthUnauthenticated());
    }
  }

  // Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    final response = await _apiService.login(
      email: email,
      password: password,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final user = data['user'] as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      // Save tokens and user info
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await TokenStorage.saveUserInfo(
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
      );

      emit(AuthAuthenticated(
        userId: user['id'].toString(),
        email: user['email'],
        name: user['name'],
        score: user['score'] ?? 0,
      ));
      
      // Trigger sync in background after login
      _triggerSync();
    } else {
      emit(AuthError(response.message));
      emit(AuthUnauthenticated());
    }
  }

  // Logout user
  Future<void> logout() async {
    emit(AuthLoading());
    
    await _apiService.logout();
    await TokenStorage.clearAll();
    
    emit(AuthUnauthenticated());
  }
}
