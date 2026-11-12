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

  const boom = Failure.server(message: 'boom');

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

  Future<HabitNotifier> buildLoadedNotifier() async {
    repository.habitsResult = right([testHabit]);
    return buildNotifier();
  }

  group('carga inicial', () {
    test('expone los hábitos cuando todo va bien', () async {
      final notifier = await buildLoadedNotifier();

      final state = notifier.state;
      expect(state, isA<HabitLoaded>());
      state as HabitLoaded;
      expect(state.habits, [testHabit]);
      expect(state.actionFailure, isNull);
    });

    test('pasa a error con el Failure si no carga', () async {
      repository.habitsResult = left(boom);

      final notifier = await buildNotifier();

      final state = notifier.state;
      expect(state, isA<HabitError>());
      expect((state as HabitError).failure, boom);
    });

    test('desde el error, reintentar vuelve a cargar los hábitos', () async {
      repository.habitsResult = left(boom);
      final notifier = await buildNotifier();
      expect(notifier.state, isA<HabitError>());

      repository.habitsResult = right([testHabit]);
      await notifier.loadHabits();

      expect(notifier.state, isA<HabitLoaded>());
    });
  });

  group('recarga con datos en pantalla', () {
    test('no pasa por Loading: la lista se mantiene mientras recarga',
            () async {
          final notifier = await buildLoadedNotifier();
          final states = <HabitState>[];
          final remove = notifier.addListener(states.add, fireImmediately: false);

          await notifier.loadHabits();
          remove();

          expect(states.whereType<HabitLoading>(), isEmpty);
          expect(states.last, isA<HabitLoaded>());
        });

    test('si la recarga falla conserva la lista y expone el fallo', () async {
      final notifier = await buildLoadedNotifier();

      repository.habitsResult = left(boom);
      await notifier.loadHabits();

      final state = notifier.state;
      expect(state, isA<HabitLoaded>());
      state as HabitLoaded;
      expect(state.habits, [testHabit]);
      expect(state.actionFailure, boom);
    });

    test('una recarga correcta limpia el fallo anterior', () async {
      final notifier = await buildLoadedNotifier();
      repository.habitsResult = left(boom);
      await notifier.loadHabits();

      repository.habitsResult = right([testHabit]);
      await notifier.loadHabits();

      expect((notifier.state as HabitLoaded).actionFailure, isNull);
    });
  });

  group('createHabit', () {
    Future<Failure?> create(HabitNotifier notifier) => notifier.createHabit(
      name: 'Leer',
      description: '20 minutos',
      frequency: 'daily',
      icon: 'book',
      color: '#7C3AED',
    );

    test('devuelve null y recarga los hábitos tras crear', () async {
      final notifier = await buildNotifier();
      final callsBefore = repository.getHabitsCalls;

      final failure = await create(notifier);
      await pumpEventQueue();

      expect(failure, isNull);
      expect(repository.getHabitsCalls, callsBefore + 1);
      expect(notifier.state, isA<HabitLoaded>());
    });

    test('si falla devuelve el Failure y NO toca la lista', () async {
      repository.createResult = left(boom);
      final notifier = await buildLoadedNotifier();
      final stateBefore = notifier.state;
      final callsBefore = repository.getHabitsCalls;

      final failure = await create(notifier);
      await pumpEventQueue();

      expect(failure, boom);
      expect(identical(notifier.state, stateBefore), isTrue);
      expect(repository.getHabitsCalls, callsBefore);
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

    test('si falla conserva la lista y expone el fallo', () async {
      const offline = Failure.network(message: 'sin red');
      repository.completeResult = left(offline);
      final notifier = await buildLoadedNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.completeHabit('h1');
      await pumpEventQueue();

      final state = notifier.state;
      expect(state, isA<HabitLoaded>());
      state as HabitLoaded;
      expect(state.habits, [testHabit]);
      expect(state.actionFailure, offline);
      expect(repository.getHabitsCalls, callsBefore);
    });
  });

  group('deleteHabit', () {
    test('borra el hábito y recarga la lista', () async {
      final notifier = await buildLoadedNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.deleteHabit('h1');
      await pumpEventQueue();

      expect(repository.deletedId, 'h1');
      expect(repository.getHabitsCalls, callsBefore + 1);
    });

    test('si el borrado falla restaura la lista y expone el fallo', () async {
      repository.deleteResult = left(boom);
      final notifier = await buildLoadedNotifier();
      final callsBefore = repository.getHabitsCalls;

      await notifier.deleteHabit('h1');
      await pumpEventQueue();

      final state = notifier.state;
      expect(state, isA<HabitLoaded>());
      state as HabitLoaded;
      expect(state.habits, [testHabit]);
      expect(state.actionFailure, boom);
      expect(repository.getHabitsCalls, callsBefore);
    });

    test('sin datos cargados no hace nada', () async {
      repository.habitsResult = left(boom);
      final notifier = await buildNotifier();

      await notifier.deleteHabit('h1');

      expect(repository.deletedId, isNull);
      expect(notifier.state, isA<HabitError>());
    });
  });
}