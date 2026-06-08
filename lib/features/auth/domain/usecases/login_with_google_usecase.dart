// Path: lib/features/auth/domain/usecases/login_with_google_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithGoogleUseCase {
  final IAuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.loginWithGoogle();
}