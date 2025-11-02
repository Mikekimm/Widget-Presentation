import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.bio,
    required super.profession,
    required super.location,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String,
      profession: json['profession'] as String,
      location: json['location'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'profession': profession,
      'location': location,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      bio: entity.bio,
      profession: entity.profession,
      location: entity.location,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}
