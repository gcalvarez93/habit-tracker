// Path: test/features/habits/habit_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeHabitDatasource datasource;
  late HabitRepositoryImpl repository;

  setUp(() {
    datasource = FakeHabitDatasource();
    repository = HabitRepositoryImpl(datasource);
  });

  test('getHabits convierte los modelos de la API en entidades', () async {
    datasource.habits = [testHabitModel];

    final result = await repository.getHabits();

    expect(result.getOrElse((_) => throw StateError('fallo')), [testHabit]);
  });

  test('getHabits devuelve Failure.server si falla la red', () async {
    datasource.error = Exception('sin red');

    final result = await repository.getHabits();

    final failure = result.swap().getOrElse((_) => throw StateError('ok'));
    expect(failure, isA<ServerFailure>());
    expect(failure.message, contains('sin red'));
  });

  test('createHabit devuelve el hábito creado como entidad', () async {
    final result = await repository.createHabit(
      name: 'Leer',
      description: '20 minutos',
      frequency: 'daily',
      icon: 'book',
      color: '#7C3AED',
    );

    expect(result.getOrElse((_) => throw StateError('fallo')), testHabit);
  });

  test('completeHabit devuelve fallo si el datasource lanza', () async {
    datasource.error = Exception('HTTP 500');

    final result = await repository.completeHabit('h1');

    expect(result.isLeft(), isTrue);
  });

  test('deleteHabit devuelve fallo si el datasource lanza', () async {
    datasource.error = Exception('HTTP 404');

    final result = await repository.deleteHabit('h1');

    expect(result.isLeft(), isTrue);
  });
}