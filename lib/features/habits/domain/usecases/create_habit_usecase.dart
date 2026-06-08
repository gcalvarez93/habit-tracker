// Path: lib/features/habits/domain/usecases/create_habit_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/i_habit_repository.dart';

class CreateHabitUseCase {
  final IHabitRepository _repository;

  CreateHabitUseCase(this._repository);

  Future<Either<Failure, HabitEntity>> call({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) =>
      _repository.createHabit(
        name: name,
        description: description,
        frequency: frequency,
        icon: icon,
        color: color,
      );
}