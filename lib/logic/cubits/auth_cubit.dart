import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/user_switcher_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    
    final result = await _authRepository.checkAuthStatus();
    
    if (result.isAuthenticated && result.user != null) {
      emit(AuthAuthenticated(
        userId: result.user!.userId,
        email: result.user!.email,
        name: result.user!.name,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }


  // Register user
  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    final result = await _authRepository.register(
      email: email,
      password: password,
    );

    if (result.isSuccess && result.user != null) {
      emit(AuthAuthenticated(
        userId: result.user!.userId,
        email: result.user!.email,
        name: result.user!.name,
      ));
    } else {
      emit(AuthError(result.errorMessage ?? 'Registration failed'));
      emit(AuthUnauthenticated());
    }
  }

  // Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (result.isSuccess && result.user != null) {
      emit(AuthAuthenticated(
        userId: result.user!.userId,
        email: result.user!.email,
        name: result.user!.name,
        score: result.user!.score,
      ));
    } else {
      emit(AuthError(result.errorMessage ?? 'Login failed'));
      emit(AuthUnauthenticated());
    }
  }

  // Logout user
  Future<void> logout() async {
    emit(AuthLoading());
    
    await _authRepository.logout();
    
    emit(AuthUnauthenticated());
  }

  // Switch to another user
  // - Updates SharedPreferences with new user ID
  // - Clears all tokens (logout)
  // - Emits AuthUnauthenticated state
  Future<void> switchUser(String userId) async {
    emit(AuthLoading());
    
    final success = await UserSwitcherService.switchUser(userId);
    
    if (success) {
      emit(AuthUnauthenticated());
    } else {
      emit(const AuthError('Failed to switch user'));
      emit(AuthUnauthenticated());
    }
  }
}
