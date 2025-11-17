import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserEntity> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const UserModel(
      id: 'user123',
      name: 'Aline Mukarurangwa',
      username: 'aline_artist',
      bio: 'speak my mind through my pen...',
      profession: 'Painter',
      location: 'Kigali',
      profileImageUrl: null,
      followersCount: 2547,
      followingCount: 342,
      postsCount: 156,
      isVerified: true,
    );
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

