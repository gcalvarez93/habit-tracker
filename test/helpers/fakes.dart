// Path: test/helpers/fakes.dart
import 'package:fpdart/fpdart.dart';
import 'package:habit_tracker/core/errors/failures.dart';
import 'package:habit_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:habit_tracker/features/auth/data/models/user_model.dart';
import 'package:habit_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:habit_tracker/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:habit_tracker/features/habits/data/datasources/habit_remote_datasource.dart';
import 'package:habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit_entity.dart';
import 'package:habit_tracker/features/habits/domain/repositories/i_habit_repository.dart';
import 'package:habit_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:habit_tracker/features/profile/domain/repositories/i_profile_repository.dart';

const testUser = UserEntity(id: 'u1', email: 'a@b.com', name: 'Ana');

final testHabit = HabitEntity(
  id: 'h1',
  name: 'Leer',
  description: '20 minutos',
  frequency: 'daily',
  icon: 'book',
  color: '#7C3AED',
  streak: 3,
  bestStreak: 5,
  totalCompleted: 12,
  completedToday: false,
  createdAt: DateTime(2026, 1, 10),
);

final testHabitModel = HabitModel(
  id: 'h1',
  name: 'Leer',
  description: '20 minutos',
  frequency: 'daily',
  icon: 'book',
  color: '#7C3AED',
  streak: 3,
  bestStreak: 5,
  totalCompleted: 12,
  completedToday: false,
  createdAt: DateTime(2026, 1, 10),
);

const testProfile = ProfileEntity(
  id: 'u1',
  name: 'Ana',
  email: 'a@b.com',
  language: 'es',
  notifications: true,
);

/// Repositorio de autenticación en memoria con resultados configurables.
class FakeAuthRepository implements IAuthRepository {
  UserEntity? currentUser;
  Either<Failure, UserEntity> loginResult = right(testUser);
  Either<Failure, UserEntity> updateNameResult = right(testUser);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async =>
      loginResult;

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async =>
      loginResult;

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async => loginResult;

  @override
  Future<Either<Failure, Unit>> logout() async {
    currentUser = null;
    return right(unit);
  }

  @override
  Future<Either<Failure, UserEntity>> updateDisplayName(String name) async =>
      updateNameResult;

  @override
  UserEntity? getCurrentUser() => currentUser;
}

/// Repositorio de hábitos en memoria con resultados configurables.
class FakeHabitRepository implements IHabitRepository {
  Either<Failure, List<HabitEntity>> habitsResult = right(<HabitEntity>[]);
  Either<Failure, HabitEntity>? createResult;
  Either<Failure, HabitEntity>? completeResult;
  Either<Failure, Unit> deleteResult = right(unit);

  int getHabitsCalls = 0;
  String? completedId;
  String? deletedId;

  @override
  Future<Either<Failure, List<HabitEntity>>> getHabits() async {
    getHabitsCalls++;
    return habitsResult;
  }

  @override
  Future<Either<Failure, HabitEntity>> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) async =>
      createResult ?? right(testHabit);

  @override
  Future<Either<Failure, HabitEntity>> completeHabit(String id) async {
    completedId = id;
    return completeResult ?? right(testHabit);
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(String id) async {
    deletedId = id;
    return deleteResult;
  }
}

/// Repositorio de perfil en memoria con resultados configurables.
class FakeProfileRepository implements IProfileRepository {
  Either<Failure, ProfileEntity> getResult = right(testProfile);
  Either<Failure, ProfileEntity>? updateResult;

  final List<String> updatedNames = [];

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async => getResult;

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String language,
    required bool notifications,
  }) async {
    updatedNames.add(name);
    return updateResult ??
        right(testProfile.copyWith(
          name: name,
          language: language,
          notifications: notifications,
        ));
  }
}

/// Datasource de hábitos en memoria. Si [error] no es nulo, todas las
/// operaciones lo lanzan.
class FakeHabitDatasource implements IHabitRemoteDatasource {
  List<HabitModel> habits = [];
  Object? error;

  @override
  Future<List<HabitModel>> getHabits() async {
    if (error != null) throw error!;
    return habits;
  }

  @override
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) async {
    if (error != null) throw error!;
    return testHabitModel;
  }

  @override
  Future<HabitModel> completeHabit(String id) async {
    if (error != null) throw error!;
    return testHabitModel;
  }

  @override
  Future<void> deleteHabit(String id) async {
    if (error != null) throw error!;
  }
}

/// Datasource de autenticación en memoria para probar el repositorio.
class FakeAuthDatasource implements IAuthRemoteDatasource {
  UserModel? updateResult;
  UserModel? currentUser;
  Object? error;

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (error != null) throw error!;
    return currentUser ?? const UserModel(id: 'u1', email: 'a@b.com');
  }

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    if (error != null) throw error!;
    return UserModel(id: 'u1', email: email, name: name);
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    if (error != null) throw error!;
    return currentUser ?? const UserModel(id: 'u1', email: 'a@b.com');
  }

  @override
  Future<void> logout() async {
    if (error != null) throw error!;
  }

  @override
  Future<UserModel?> updateDisplayName(String name) async {
    if (error != null) throw error!;
    return updateResult;
  }

  @override
  UserModel? getCurrentUser() => currentUser;
}