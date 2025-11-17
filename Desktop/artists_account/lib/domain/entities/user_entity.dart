import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String profession;
  final String location;
  final String? profileImageUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.profession,
    required this.location,
    this.profileImageUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        bio,
        profession,
        location,
        profileImageUrl,
        followersCount,
        followingCount,
        postsCount,
        isVerified,
      ];
}
