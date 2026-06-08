// Path: lib/features/profile/domain/entities/profile_entity.dart

class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String language;
  final bool notifications;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.language,
    required this.notifications,
  });

  ProfileEntity copyWith({
    String? name,
    String? photoUrl,
    String? language,
    bool? notifications,
  }) =>
      ProfileEntity(
        id: id,
        name: name ?? this.name,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        language: language ?? this.language,
        notifications: notifications ?? this.notifications,
      );
}