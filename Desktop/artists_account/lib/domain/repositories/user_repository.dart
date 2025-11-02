import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String userId);
  Future<void> updateUser(UserEntity user);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
}
