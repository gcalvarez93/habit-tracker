// Path: lib/features/habits/data/repositories/habit_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../datasources/habit_remote_datasource.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements IHabitRepository {
  final IHabitRemoteDatasource _datasource;

  HabitRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<HabitEntity>>> getHabits() async {
    try {
      final models = await _datasource.getHabits();
      return right(models.map(_mapToEntity).toList());
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HabitEntity>> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) async {
    try {
      final model = await _datasource.createHabit(
        name: name,
        description: description,
        frequency: frequency,
        icon: icon,
        color: color,
      );
      return right(_mapToEntity(model));
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HabitEntity>> completeHabit(String id) async {
    try {
      final model = await _datasource.completeHabit(id);
      return right(_mapToEntity(model));
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(String id) async {
    try {
      await _datasource.deleteHabit(id);
      return right(unit);
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  HabitEntity _mapToEntity(HabitModel model) => HabitEntity(
    id: model.id,
    name: model.name,
    description: model.description,
    frequency: model.frequency,
    icon: model.icon,
    color: model.color,
    streak: model.streak,
    bestStreak: model.bestStreak,
    totalCompleted: model.totalCompleted,
    completedToday: model.completedToday,
    createdAt: model.createdAt,
  );
}