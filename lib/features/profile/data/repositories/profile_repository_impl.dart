// Path: lib/features/profile/data/repositories/profile_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDatasource _datasource;

  ProfileRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final model = await _datasource.getProfile();
      return right(model.toEntity());
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String name,
    required String language,
    required bool notifications,
  }) async {
    try {
      final model = await _datasource.updateProfile(
        name: name,
        language: language,
        notifications: notifications,
      );
      return right(model.toEntity());
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }
}