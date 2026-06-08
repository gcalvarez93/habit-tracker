// Path: lib/features/auth/presentation/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/login_with_email_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_with_email_usecase.dart';

final authDatasourceProvider = Provider<IAuthRemoteDatasource>(
      (ref) => AuthRemoteDatasource(),
);

final authRepositoryProvider = Provider<IAuthRepository>(
      (ref) => AuthRepositoryImpl(ref.watch(authDatasourceProvider)),
);

final loginWithEmailUseCaseProvider = Provider(
      (ref) => LoginWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

final registerWithEmailUseCaseProvider = Provider(
      (ref) => RegisterWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

final loginWithGoogleUseCaseProvider = Provider(
      (ref) => LoginWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider(
      (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginWithEmailUseCase _loginWithEmail;
  final RegisterWithEmailUseCase _registerWithEmail;
  final LoginWithGoogleUseCase _loginWithGoogle;
  final LogoutUseCase _logout;
  final IAuthRepository _repository;

  AuthNotifier({
    required LoginWithEmailUseCase loginWithEmail,
    required RegisterWithEmailUseCase registerWithEmail,
    required LoginWithGoogleUseCase loginWithGoogle,
    required LogoutUseCase logout,
    required IAuthRepository repository,
  })  : _loginWithEmail = loginWithEmail,
        _registerWithEmail = registerWithEmail,
        _loginWithGoogle = loginWithGoogle,
        _logout = logout,
        _repository = repository,
        super(AuthInitial()) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final user = _repository.getCurrentUser();
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<void> refreshUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = _repository.getCurrentUser();
    if (user != null) state = AuthAuthenticated(user);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    final result = await _loginWithEmail(email: email, password: password);
    result.fold(
          (failure) => state = AuthError(_mapFailureMessage(failure)),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = AuthLoading();
    final result = await _registerWithEmail(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
          (failure) => state = AuthError(_mapFailureMessage(failure)),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> loginWithGoogle() async {
    state = AuthLoading();
    final result = await _loginWithGoogle();
    result.fold(
          (failure) => state = AuthError(_mapFailureMessage(failure)),
          (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    state = AuthLoading();
    final result = await _logout();
    result.fold(
          (failure) => state = AuthError(_mapFailureMessage(failure)),
          (_) => state = AuthUnauthenticated(),
    );
  }

  String _mapFailureMessage(Failure failure) => failure.when(
    network: (message) => message,
    server: (message) => message,
    auth: (message) => message,
    unknown: (message) => 'Error desconocido',
  );
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(
    loginWithEmail: ref.watch(loginWithEmailUseCaseProvider),
    registerWithEmail: ref.watch(registerWithEmailUseCaseProvider),
    loginWithGoogle: ref.watch(loginWithGoogleUseCaseProvider),
    logout: ref.watch(logoutUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  ),
);