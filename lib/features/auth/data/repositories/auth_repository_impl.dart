// Path: lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _datasource.loginWithEmail(
        email: email,
        password: password,
      );
      return right(_mapToEntity(model));
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.loginWithEmail', e, st);
      return left(Failure.auth(message: e.message ?? 'Error de autenticación'));
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.loginWithEmail', e, st);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final model = await _datasource.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
      return right(_mapToEntity(model));
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.registerWithEmail', e, st);
      return left(Failure.auth(message: e.message ?? 'Error de registro'));
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.registerWithEmail', e, st);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final model = await _datasource.loginWithGoogle();
      return right(_mapToEntity(model));
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.loginWithGoogle', e, st);
      return left(Failure.auth(message: e.message ?? 'Error con Google'));
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.loginWithGoogle', e, st);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _datasource.logout();
      return right(unit);
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.logout', e, st);
      return left(Failure.auth(message: e.message ?? 'Error al cerrar sesión'));
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.logout', e, st);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateDisplayName(String name) async {
    try {
      final model = await _datasource.updateDisplayName(name);
      if (model == null) {
        return left(const Failure.auth(message: 'No hay sesión activa'));
      }
      return right(_mapToEntity(model));
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.updateDisplayName', e, st);
      return left(Failure.auth(message: e.message ?? 'Error al actualizar el nombre'));
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.updateDisplayName', e, st);
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    final model = _datasource.getCurrentUser();
    if (model == null) return null;
    return _mapToEntity(model);
  }

  UserEntity _mapToEntity(UserModel model) => UserEntity(
    id: model.id,
    email: model.email,
    name: model.name,
    photoUrl: model.photoUrl,
  );
}