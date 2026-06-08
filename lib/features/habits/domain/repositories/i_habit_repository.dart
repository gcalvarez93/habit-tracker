// Path: lib/features/habits/domain/repositories/i_habit_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';

abstract interface class IHabitRepository {
  Future<Either<Failure, List<HabitEntity>>> getHabits();
  Future<Either<Failure, HabitEntity>> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  });
  Future<Either<Failure, HabitEntity>> completeHabit(String id);
  Future<Either<Failure, Unit>> deleteHabit(String id);
}