// Path: lib/features/auth/domain/usecases/login_with_email_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithEmailUseCase {
  final IAuthRepository _repository;

  LoginWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) =>
      _repository.loginWithEmail(email: email, password: password);
}