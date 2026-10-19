// Path: test/features/profile/profile_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:habit_tracker/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:habit_tracker/features/profile/presentation/providers/profile_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeProfileRepository repository;

  setUp(() => repository = FakeProfileRepository());

  Future<ProfileNotifier> buildNotifier() async {
    final notifier = ProfileNotifier(
      getProfile: GetProfileUseCase(repository),
      updateProfile: UpdateProfileUseCase(repository),
    );
    await pumpEventQueue();
    return notifier;
  }

  test('carga el perfil al crearse', () async {
    final notifier = await buildNotifier();

    final state = notifier.state;
    expect(state, isA<ProfileLoaded>());
    expect((state as ProfileLoaded).profile.name, 'Ana');
  });

  test('pasa a error con el mensaje del fallo si no carga', () async {
    repository.getResult = left(const Failure.server(message: 'boom'));

    final notifier = await buildNotifier();

    final state = notifier.state;
    expect(state, isA<ProfileError>());
    expect((state as ProfileError).message, 'boom');
  });

  group('updateProfile', () {
    test('devuelve true y publica el perfil guardado', () async {
      final notifier = await buildNotifier();

      final ok = await notifier.updateProfile(
        name: 'Nuevo nombre',
        language: 'en',
        notifications: false,
      );

      expect(ok, isTrue);
      final profile = (notifier.state as ProfileLoaded).profile;
      expect(profile.name, 'Nuevo nombre');
      expect(profile.language, 'en');
      expect(profile.notifications, isFalse);
    });

    test('devuelve false y restaura el perfil anterior si falla', () async {
      final notifier = await buildNotifier();
      repository.updateResult = left(const Failure.server(message: 'boom'));

      final ok = await notifier.updateProfile(
        name: 'Nuevo nombre',
        language: 'en',
        notifications: false,
      );

      expect(ok, isFalse);
      final profile = (notifier.state as ProfileLoaded).profile;
      expect(profile.name, 'Ana');
      expect(profile.language, 'es');
      expect(profile.notifications, isTrue);
    });
  });
}