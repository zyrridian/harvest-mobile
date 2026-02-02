import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../data/services/authentication_service.dart';
import '../../domain/entities/user.dart';

/// Auth state enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isFirstLaunch;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isFirstLaunch = true,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isFirstLaunch,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

/// Auth controller notifier
class AuthController extends StateNotifier<AuthState> {
  final AuthenticationService _authService;
  final PreferencesService _preferencesService;

  AuthController(this._authService, this._preferencesService)
      : super(const AuthState());

  /// Initialize auth state - check if user is logged in
  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Check first launch
      final isFirstLaunch = _preferencesService.isFirstLaunch();

      // Check if authenticated
      final isAuthenticated = await _authService.isAuthenticated();

      if (isAuthenticated) {
        // Try to get stored user
        final storedUser = await _authService.getStoredUser();

        if (storedUser != null) {
          state = AuthState(
            status: AuthStatus.authenticated,
            user: storedUser.toEntity(),
            isFirstLaunch: isFirstLaunch,
          );
        } else {
          // Try to fetch user from API
          try {
            final user = await _authService.getCurrentUser();
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user.toEntity(),
              isFirstLaunch: isFirstLaunch,
            );
          } catch (e) {
            // Failed to get user, logout
            await _authService.logout();
            state = AuthState(
              status: AuthStatus.unauthenticated,
              isFirstLaunch: isFirstLaunch,
            );
          }
        }
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          isFirstLaunch: isFirstLaunch,
        );
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isFirstLaunch: _preferencesService.isFirstLaunch(),
        errorMessage: e.toString(),
      );
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      state = AuthState(
        status: AuthStatus.authenticated,
        user: authResponse.user.toEntity(),
        isFirstLaunch: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Register a new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final authResponse = await _authService.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );

      state = AuthState(
        status: AuthStatus.authenticated,
        user: authResponse.user.toEntity(),
        isFirstLaunch: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    await _authService.logout();

    state = const AuthState(
      status: AuthStatus.unauthenticated,
      isFirstLaunch: false,
    );
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    await _preferencesService.setFirstLaunchComplete();
    state = state.copyWith(isFirstLaunch: false);
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(user: user.toEntity());
    } catch (e) {
      // Silently fail, keep current user data
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authenticationServiceProvider);
  final preferencesService = ref.watch(preferencesServiceProvider);

  return AuthController(authService, preferencesService);
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Provider to get current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authControllerProvider).user;
});

/// Provider to check if it's first launch
final isFirstLaunchProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isFirstLaunch;
});
