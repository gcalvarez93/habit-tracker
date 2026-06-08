// Path: lib/features/habits/data/datasources/habit_remote_datasource.dart
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/habit_model.dart';

abstract interface class IHabitRemoteDatasource {
  Future<List<HabitModel>> getHabits();
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  });
  Future<HabitModel> completeHabit(String id);
  Future<void> deleteHabit(String id);
}

class HabitRemoteDatasource implements IHabitRemoteDatasource {
  final DioClient _client;

  HabitRemoteDatasource(this._client);

  @override
  Future<List<HabitModel>> getHabits() async {
    final response = await _client.get(ApiConfig.habits);
    final List data = response.data as List;
    return data.map((e) => HabitModel.fromJson(e)).toList();
  }

  @override
  Future<HabitModel> createHabit({
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
  }) async {
    final response = await _client.post(ApiConfig.habits, data: {
      'name': name,
      'description': description,
      'frequency': frequency,
      'icon': icon,
      'color': color,
    });
    return HabitModel.fromJson(response.data);
  }

  @override
  Future<HabitModel> completeHabit(String id) async {
    final response = await _client.post('${ApiConfig.habits}/$id/complete');
    return HabitModel.fromJson(response.data);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _client.delete('${ApiConfig.habits}/$id');
  }
}