// Path: lib/features/habits/presentation/providers/habit_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
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

  /// Fallo de la última operación (recarga, completar o borrar) que NO
  /// invalida los datos mostrados. La UI lo avisa con un SnackBar.
  final Failure? actionFailure;

  HabitLoaded(this.habits, {this.actionFailure});
}
/// Fallo de carga SIN datos que mostrar (pantalla de error con reintento).
class HabitError extends HabitState {
  final Failure failure;
  HabitError(this.failure);
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

  /// Carga (o recarga) los hábitos.
  ///
  /// Si ya hay datos en pantalla se conservan mientras se recarga y, si la
  /// recarga falla, siguen visibles con [HabitLoaded.actionFailure]. Solo se
  /// pasa a [HabitLoading] o [HabitError] cuando no hay nada que enseñar.
  Future<void> loadHabits() async {
    if (state is! HabitLoaded) state = HabitLoading();

    final result = await _getHabits();

    final current = state;
    result.fold(
          (failure) {
        state = current is HabitLoaded
            ? HabitLoaded(current.habits, actionFailure: failure)
            : HabitError(failure);
      },
          (habits) {
        state = HabitLoaded(habits);
      },
    );
  }

  /// Crea un hábito. Devuelve `null` si todo fue bien o el [Failure] si
  /// falló. No toca el estado de la lista en caso de fallo: el formulario
  /// decide cómo mostrar el error y conserva lo que escribió el usuario.
  Future<Failure?> createHabit({
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

    return result.fold<Failure?>(
          (failure) => failure,
          (_) {
        unawaited(loadHabits());
        return null;
      },
    );
  }

  /// Marca el hábito como completado. Si falla, la lista se conserva y se
  /// expone el fallo en [HabitLoaded.actionFailure].
  Future<void> completeHabit(String id) async {
    final result = await _completeHabit(id);
    result.fold(
          (failure) {
        final current = state;
        if (current is HabitLoaded) {
          state = HabitLoaded(current.habits, actionFailure: failure);
        }
      },
          (_) {
        unawaited(loadHabits());
      },
    );
  }

  /// Borra con eliminación optimista: el hábito desaparece al instante y, si
  /// el servidor falla, se restaura la lista y se avisa del error.
  Future<void> deleteHabit(String id) async {
    final current = state;
    if (current is! HabitLoaded) return;

    state = HabitLoaded(current.habits.where((h) => h.id != id).toList());

    final result = await _deleteHabit(id);
    result.fold(
          (failure) {
        state = HabitLoaded(current.habits, actionFailure: failure);
      },
          (_) {
        unawaited(loadHabits());
      },
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