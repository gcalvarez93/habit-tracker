// Path: test/features/habits/habit_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/habits/domain/usecases/complete_habit_usecase.dart';
import 'package:habit_tracker/features/habits/domain/usecases/create_habit_usecase.dart';
import 'package:habit_tracker/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:habit_tracker/features/habits/domain/usecases/get_habits_usecase.dart';
import 'package:habit_tracker/features/habits/presentation/providers/habit_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeHabitRepository repository;

  setUp(() => repository = FakeHabitRepository());

  Future<HabitNotifier> buildNotifier() async {
    final notifier = HabitNotifier(
      getHabits: GetHabitsUseCase(repository),
      createHabit: CreateHabitUseCase(repository),
      completeHabit: CompleteHabitUseCase(repository),
      deleteHabit: DeleteHabitUseCase(repository),
    );
    await pumpEventQueue();
    return notifier;
  }

  group('carga inicial', () {
    test('expone los hábitos cuando todo va bien', () async {
      repository.habitsResult = right([testHabit]);

      final notifier = await buildNotifier();

      final state = notifier.state;
      expect(state, isA<HabitLoaded>());
      expect((state as HabitLoaded).habits, [testHabit]);
    });

    test('pasa a error con el mensaje del fallo', () async {
      repository.habitsResult = left(const Failure.server(message: 'boom'));

      final notifier = await buildNotifier();

      final state = notifier.state;
      expect(state, isA<HabitError>());
      expect((state as HabitError).message, 'boom');
    });
  });

  group('createHabit', () {
    test('recarga los hábitos tras crear', () async {
      final notifier = await buildNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.createHabit(
        name: 'Leer',
        description: '20 minutos',
        frequency: 'daily',
        icon: 'book',
        color: '#7C3AED',
      );
      await pumpEventQueue();

      expect(repository.getHabitsCalls, callsBefore + 1);
      expect(notifier.state, isA<HabitLoaded>());
    });

    test('pasa a error si el repositorio falla', () async {
      repository.createResult = left(const Failure.server(message: 'boom'));
      final notifier = await buildNotifier();

      await notifier.createHabit(
        name: 'Leer',
        description: '',
        frequency: 'daily',
        icon: 'book',
        color: '#7C3AED',
      );

      expect(notifier.state, isA<HabitError>());
    });
  });

  group('completeHabit', () {
    test('completa el hábito y recarga la lista', () async {
      final notifier = await buildNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.completeHabit('h1');
      await pumpEventQueue();

      expect(repository.completedId, 'h1');
      expect(repository.getHabitsCalls, callsBefore + 1);
    });

    test('pasa a error si no se pudo completar', () async {
      repository.completeResult =
          left(const Failure.network(message: 'sin red'));
      final notifier = await buildNotifier();

      await notifier.completeHabit('h1');

      final state = notifier.state;
      expect(state, isA<HabitError>());
      expect((state as HabitError).message, 'sin red');
    });
  });

  group('deleteHabit', () {
    test('borra el hábito y recarga la lista', () async {
      final notifier = await buildNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.deleteHabit('h1');
      await pumpEventQueue();

      expect(repository.deletedId, 'h1');
      expect(repository.getHabitsCalls, callsBefore + 1);
    });

    test('pasa a error si el borrado falla y no recarga', () async {
      repository.deleteResult = left(const Failure.server(message: 'boom'));
      final notifier = await buildNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.deleteHabit('h1');
      await pumpEventQueue();

      expect(notifier.state, isA<HabitError>());
      expect(repository.getHabitsCalls, callsBefore);
    });
  });
}