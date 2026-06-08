// Path: lib/features/profile/domain/usecases/update_profile_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, ProfileEntity>> call({
    required String name,
    required String language,
    required bool notifications,
  }) =>
      _repository.updateProfile(
        name: name,
        language: language,
        notifications: notifications,
      );
}