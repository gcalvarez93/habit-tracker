// Path: lib/features/habits/presentation/providers/habit_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/habit_remote_datasource.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/get_habits_usecase.dart';

// Datasource
final habitDatasourceProvider = Provider<IHabitRemoteDatasource>(
      (ref) => HabitRemoteDatasource(ref.watch(dioClientProvider)),
);

// Repository
final habitRepositoryProvider = Provider<IHabitRepository>(
      (ref) => HabitRepositoryImpl(ref.watch(habitDatasourceProvider)),
);

// Use Cases
final getHabitsUseCaseProvider = Provider(
      (ref) => GetHabitsUseCase(ref.watch(habitRepositoryProvider)),
);

final createHabitUseCaseProvider = Provider(
      (ref) => CreateHabitUseCase(ref.watch(habitRepositoryProvider)),
);

final completeHabitUseCaseProvider = Provider(
      (ref) => CompleteHabitUseCase(ref.watch(habitRepositoryProvider)),
);

final deleteHabitUseCaseProvider = Provider(
      (ref) => DeleteHabitUseCase(ref.watch(habitRepositoryProvider)),
);

// State
sealed class HabitState {}
class HabitInitial extends HabitState {}
class HabitLoading extends HabitState {}
class HabitLoaded extends HabitState {
  final List<HabitEntity> habits;
  HabitLoaded(this.habits);
}
class HabitError extends HabitState {
  final String message;
  HabitError(this.message);
}

// Notifier
class HabitNotifier extends StateNotifier<HabitState> {
  final GetHabitsUseCase _getHabits;
  final CreateHabitUseCase _createHabit;
  final CompleteHabitUseCase _completeHabit;
  final DeleteHabitUseCase _deleteHabit;

  HabitNotifier({
    required GetHabitsUseCase getHabits,
    required CreateHabitUseCase createHabit,
    required CompleteHabitUseCase completeHabit,
    required DeleteHabitUseCase deleteHabit,
  })  : _getHabits = getHabits,
        _createHabit = createHabit,
        _completeHabit = completeHabit,
        _deleteHabit = deleteHabit,
        super(HabitInitial()) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    state = HabitLoading();
    final result = await _getHabits();
    result.fold(
          (failure) => state = HabitError(failure.toString()),
          (habits) => state = HabitLoaded(habits),
    );
  }

  Future<void> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) async {
    final result = await _createHabit(
      name: name,
      description: description,
      frequency: frequency,
      icon: icon,
      color: color,
    );
    result.fold(
          (failure) => state = HabitError(failure.toString()),
          (_) => loadHabits(),
    );
  }

  Future<void> completeHabit(String id) async {
    final result = await _completeHabit(id);
    result.fold(
          (failure) => state = HabitError(failure.toString()),
          (_) => loadHabits(),
    );
  }

  Future<void> deleteHabit(String id) async {
    final result = await _deleteHabit(id);
    result.fold(
          (failure) => state = HabitError(failure.toString()),
          (_) => loadHabits(),
    );
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>(
      (ref) => HabitNotifier(
    getHabits: ref.watch(getHabitsUseCaseProvider),
    createHabit: ref.watch(createHabitUseCaseProvider),
    completeHabit: ref.watch(completeHabitUseCaseProvider),
    deleteHabit: ref.watch(deleteHabitUseCaseProvider),
  ),
);