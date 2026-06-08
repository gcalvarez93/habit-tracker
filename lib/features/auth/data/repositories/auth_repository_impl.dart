// Path: lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
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
    } catch (e) {
      return left(Failure.auth(message: e.toString()));
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
    } catch (e) {
      return left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final model = await _datasource.loginWithGoogle();
      return right(_mapToEntity(model));
    } catch (e) {
      return left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _datasource.logout();
      return right(unit);
    } catch (e) {
      return left(Failure.auth(message: e.toString()));
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