import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/get_current_usecase.dart';
import '../../domain/usecases/auth/is_logged_in_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../core/providers/dio_provider.dart';
import '../../core/providers/db_provider.dart';

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
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final PreferencesService _preferencesService;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
    this._isLoggedInUseCase,
    this._preferencesService,
  ) : super(const AuthState());

  /// Initialize auth state - check if user is logged in
  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Check first launch
      final isFirstLaunch = _preferencesService.isFirstLaunch();

      // Check if authenticated
      final isAuthenticated = await _isLoggedInUseCase();

      if (isAuthenticated) {
        final result = await _getCurrentUserUseCase();

        result.fold(
          (failure) async {
            await _logoutUseCase();
            state = AuthState(
              status: AuthStatus.unauthenticated,
              isFirstLaunch: isFirstLaunch,
            );
          },
          (user) {
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
              isFirstLaunch: isFirstLaunch,
            );
          },
        );
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

    final result = await _loginUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          isFirstLaunch: false,
        );
        return true;
      },
    );
  }

  /// Register a new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          isFirstLaunch: false,
        );
        return true;
      },
    );
  }

  /// Logout the current user
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    await _logoutUseCase();

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

    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) {
        // Silently fail, keep current user data
      },
      (user) {
        state = state.copyWith(user: user);
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(dio),
    localDataSource: AuthLocalDataSourceImpl(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    ),
  );
});

/// Use Case Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final isLoggedInUseCaseProvider = Provider<IsLoggedInUseCase>((ref) {
  return IsLoggedInUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final preferencesService = ref.watch(preferencesServiceProvider);

  return AuthController(
    ref.watch(loginUseCaseProvider),
    ref.watch(registerUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(getCurrentUserUseCaseProvider),
    ref.watch(isLoggedInUseCaseProvider),
    preferencesService,
  );
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
