// Path: test/features/auth/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/auth/data/models/user_model.dart';
import 'package:habit_tracker/features/auth/data/repositories/auth_repository_impl.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAuthDatasource datasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    datasource = FakeAuthDatasource();
    repository = AuthRepositoryImpl(datasource);
  });

  group('loginWithEmail', () {
    test('convierte el modelo en entidad', () async {
      datasource.currentUser =
      const UserModel(id: 'u9', email: 'x@y.com', name: 'Eva');

      final result = await repository.loginWithEmail(
        email: 'x@y.com',
        password: '123456',
      );

      final user = result.getOrElse((_) => throw StateError('fallo'));
      expect(user.id, 'u9');
      expect(user.email, 'x@y.com');
      expect(user.name, 'Eva');
    });

    test('devuelve Failure.auth si el datasource lanza', () async {
      datasource.error = Exception('credenciales inválidas');

      final result = await repository.loginWithEmail(
        email: 'x@y.com',
        password: 'mal',
      );

      final failure = result.swap().getOrElse((_) => throw StateError('ok'));
      expect(failure, isA<AuthFailure>());
      expect(failure.message, contains('credenciales inválidas'));
    });
  });

  group('updateDisplayName', () {
    test('devuelve el usuario actualizado', () async {
      datasource.updateResult =
      const UserModel(id: 'u1', email: 'a@b.com', name: 'Nuevo');

      final result = await repository.updateDisplayName('Nuevo');

      final user = result.getOrElse((_) => throw StateError('fallo'));
      expect(user.name, 'Nuevo');
    });

    test('devuelve Failure.auth si no hay sesión activa', () async {
      datasource.updateResult = null;

      final result = await repository.updateDisplayName('Nuevo');

      final failure = result.swap().getOrElse((_) => throw StateError('ok'));
      expect(failure, isA<AuthFailure>());
    });

    test('devuelve Failure.auth si Firebase falla', () async {
      datasource.error = Exception('network-request-failed');

      final result = await repository.updateDisplayName('Nuevo');

      expect(result.isLeft(), isTrue);
    });
  });

  test('getCurrentUser devuelve null sin sesión', () {
    datasource.currentUser = null;

    expect(repository.getCurrentUser(), isNull);
  });
}