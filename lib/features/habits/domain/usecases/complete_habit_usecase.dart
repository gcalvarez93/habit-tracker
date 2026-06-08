// Path: lib/features/habits/domain/usecases/complete_habit_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/i_habit_repository.dart';

class CompleteHabitUseCase {
  final IHabitRepository _repository;

  CompleteHabitUseCase(this._repository);

  Future<Either<Failure, HabitEntity>> call(String id) =>
      _repository.completeHabit(id);
}