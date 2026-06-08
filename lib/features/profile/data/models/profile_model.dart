// Path: lib/features/profile/data/models/profile_model.dart
import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String language;
  final bool notifications;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.language,
    required this.notifications,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photoUrl: json['photoUrl'] as String?,
    language: json['language'] as String? ?? 'es',
    notifications: json['notifications'] as bool? ?? true,
  );

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    name: name,
    email: email,
    photoUrl: photoUrl,
    language: language,
    notifications: notifications,
  );
}