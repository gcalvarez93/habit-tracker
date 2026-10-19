// Path: test/features/auth/auth_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/auth/domain/usecases/login_with_email_usecase.dart';
import 'package:habit_tracker/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:habit_tracker/features/auth/domain/usecases/logout_usecase.dart';
import 'package:habit_tracker/features/auth/domain/usecases/register_with_email_usecase.dart';
import 'package:habit_tracker/features/auth/domain/usecases/update_display_name_usecase.dart';
import 'package:habit_tracker/features/auth/presentation/providers/auth_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  AuthNotifier buildNotifier() => AuthNotifier(
    loginWithEmail: LoginWithEmailUseCase(repository),
    registerWithEmail: RegisterWithEmailUseCase(repository),
    loginWithGoogle: LoginWithGoogleUseCase(repository),
    logout: LogoutUseCase(repository),
    updateDisplayName: UpdateDisplayNameUseCase(repository),
    repository: repository,
  );

  test('arranca autenticado si ya hay sesión', () {
    repository.currentUser = testUser;

    expect(buildNotifier().state, isA<AuthAuthenticated>());
  });

  test('arranca sin autenticar si no hay sesión', () {
    expect(buildNotifier().state, isA<AuthUnauthenticated>());
  });

  test('login correcto deja el estado autenticado', () async {
    final notifier = buildNotifier();

    await notifier.loginWithEmail(email: 'a@b.com', password: '123456');

    final state = notifier.state;
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, testUser);
  });

  test('login fallido propaga el mensaje de auth', () async {
    repository.loginResult =
        left(const Failure.auth(message: 'Contraseña incorrecta'));
    final notifier = buildNotifier();

    await notifier.loginWithEmail(email: 'a@b.com', password: 'mal');

    final state = notifier.state;
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Contraseña incorrecta');
  });

  test('un fallo desconocido no filtra el detalle interno', () async {
    repository.loginResult = left(const Failure.unknown(message: 'stacktrace'));
    final notifier = buildNotifier();

    await notifier.loginWithEmail(email: 'a@b.com', password: '123456');

    expect((notifier.state as AuthError).message, 'Error desconocido');
  });

  test('logout deja el estado sin autenticar', () async {
    repository.currentUser = testUser;
    final notifier = buildNotifier();

    await notifier.logout();

    expect(notifier.state, isA<AuthUnauthenticated>());
  });

  group('updateDisplayName', () {
    test('devuelve true y actualiza el usuario', () async {
      repository.currentUser = testUser;
      repository.updateNameResult =
          right(testUser.copyWith(name: 'Nuevo nombre'));
      final notifier = buildNotifier();

      final ok = await notifier.updateDisplayName('Nuevo nombre');

      expect(ok, isTrue);
      expect((notifier.state as AuthAuthenticated).user.name, 'Nuevo nombre');
    });

    test('devuelve false y mantiene la sesión si falla', () async {
      repository.currentUser = testUser;
      repository.updateNameResult = left(const Failure.auth(message: 'x'));
      final notifier = buildNotifier();

      final ok = await notifier.updateDisplayName('Nuevo nombre');

      expect(ok, isFalse);
      expect(notifier.state, isA<AuthAuthenticated>());
    });
  });
}