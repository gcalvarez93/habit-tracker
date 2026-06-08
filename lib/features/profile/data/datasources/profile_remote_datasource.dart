// Path: lib/features/profile/data/datasources/profile_remote_datasource.dart
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/profile_model.dart';

abstract interface class IProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    required String language,
    required bool notifications,
  });
}

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final DioClient _client;

  ProfileRemoteDatasource(this._client);

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _client.get(ApiConfig.userMe);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String language,
    required bool notifications,
  }) async {
    final response = await _client.put(ApiConfig.userMe, data: {
      'name': name,
      'language': language,
      'notifications': notifications,
      'photoUrl': '',
    });
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}