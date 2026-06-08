// Path: lib/features/habits/domain/entities/habit_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_entity.freezed.dart';

@freezed
class HabitEntity with _$HabitEntity {
  const factory HabitEntity({
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
  }) = _HabitEntity;
}