// Path: lib/features/auth/domain/repositories/i_auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, Unit>> logout();
  UserEntity? getCurrentUser();
}