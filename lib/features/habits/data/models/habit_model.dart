// Path: lib/features/habits/data/models/habit_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    required String name,
    required String description,
    required String frequency,
    required String icon,
    required String color,
    required int streak,
    required int bestStreak,
    required int totalCompleted,
    required bool completedToday,
    required DateTime createdAt,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}