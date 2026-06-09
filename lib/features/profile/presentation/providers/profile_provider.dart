// Path: lib/features/profile/presentation/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

final profileDatasourceProvider = Provider<IProfileRemoteDatasource>(
      (ref) => ProfileRemoteDatasource(ref.watch(dioClientProvider)),
);

final profileRepositoryProvider = Provider<IProfileRepository>(
      (ref) => ProfileRepositoryImpl(ref.watch(profileDatasourceProvider)),
);

final getProfileUseCaseProvider = Provider(
      (ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)),
);

final updateProfileUseCaseProvider = Provider(
      (ref) => UpdateProfileUseCase(ref.watch(profileRepositoryProvider)),
);

sealed class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  ProfileNotifier({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = ProfileLoading();
    final result = await _getProfile();
    result.fold(
          (failure) => state = ProfileError(failure.toString()),
          (profile) => state = ProfileLoaded(profile),
    );
  }

  Future<bool> updateProfile({
    required String name,
    required String language,
    required bool notifications,
  }) async {
    // Actualiza el estado localmente sin pasar por Loading
    final current = state;
    if (current is ProfileLoaded) {
      state = ProfileLoaded(current.profile.copyWith(
        name: name,
        language: language,
        notifications: notifications,
      ));
    }

    // Guarda en la API en segundo plano
    final result = await _updateProfile(
      name: name,
      language: language,
      notifications: notifications,
    );

    return result.fold(
          (failure) {
        // Si falla, restaura el estado anterior
        state = current;
        return false;
      },
          (profile) {
        state = ProfileLoaded(profile);
        return true;
      },
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(
    getProfile: ref.watch(getProfileUseCaseProvider),
    updateProfile: ref.watch(updateProfileUseCaseProvider),
  ),
);