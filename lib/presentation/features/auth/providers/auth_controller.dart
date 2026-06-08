import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/data/datasources/local/auth_local_datasource.dart';
import 'package:harvest_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:harvest_app/data/repositories/auth_repository_impl.dart';
import 'package:harvest_app/domain/repositories/auth_repository.dart';
import 'package:harvest_app/domain/usecases/auth/get_current_usecase.dart';
import 'package:harvest_app/domain/usecases/auth/login_usecase.dart';
import 'package:harvest_app/domain/usecases/auth/logout_usecase.dart';
import 'package:harvest_app/domain/usecases/auth/register_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

// Repository Provider
@riverpod
AuthRepository authRepository(Ref ref) {
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
}

// Use Cases Providers
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

// Auth Controller
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // We don't call checkAuthStatus here to avoid unawaited futures.
    // Splash screen will call it.
    return const AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    final repository = ref.read(authRepositoryProvider);
    final isLoggedIn = await repository.isLoggedIn();

    if (isLoggedIn) {
      final result = await ref.read(getCurrentUserUseCaseProvider).call();

      result.fold(
        (failure) => state = const AuthState.unauthenticated(),
        (user) => state = AuthState.authenticated(user),
      );
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await ref.read(loginUseCaseProvider).call(
          email: email,
          password: password,
        );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    final result = await ref.read(logoutUseCaseProvider).call();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    state = const AuthState.loading();

    final result = await ref.read(registerUseCaseProvider).call(
          email: email,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
        );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> getCurrentUser() async {
    state = const AuthState.loading();

    final result = await ref.read(getCurrentUserUseCaseProvider).call();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }
}
