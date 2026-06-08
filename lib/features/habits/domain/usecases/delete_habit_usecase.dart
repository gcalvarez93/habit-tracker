// Path: lib/features/habits/domain/usecases/delete_habit_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/i_habit_repository.dart';

class DeleteHabitUseCase {
  final IHabitRepository _repository;

  DeleteHabitUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) => _repository.deleteHabit(id);
}