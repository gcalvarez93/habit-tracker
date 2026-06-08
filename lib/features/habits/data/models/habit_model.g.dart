// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitModelImpl _$$HabitModelImplFromJson(Map<String, dynamic> json) =>
    _$HabitModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      frequency: json['frequency'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      streak: (json['streak'] as num).toInt(),
      bestStreak: (json['bestStreak'] as num).toInt(),
      totalCompleted: (json['totalCompleted'] as num).toInt(),
      completedToday: json['completedToday'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HabitModelImplToJson(_$HabitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'frequency': instance.frequency,
      'icon': instance.icon,
      'color': instance.color,
      'streak': instance.streak,
      'bestStreak': instance.bestStreak,
      'totalCompleted': instance.totalCompleted,
      'completedToday': instance.completedToday,
      'createdAt': instance.createdAt.toIso8601String(),
    };
