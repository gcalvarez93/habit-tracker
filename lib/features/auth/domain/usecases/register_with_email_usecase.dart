// Path: lib/features/auth/domain/usecases/register_with_email_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class RegisterWithEmailUseCase {
  final IAuthRepository _repository;

  RegisterWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) =>
      _repository.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
}