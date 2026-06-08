// Path: lib/features/habits/domain/usecases/get_habits_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/i_habit_repository.dart';

class GetHabitsUseCase {
  final IHabitRepository _repository;

  GetHabitsUseCase(this._repository);

  Future<Either<Failure, List<HabitEntity>>> call() => _repository.getHabits();
}