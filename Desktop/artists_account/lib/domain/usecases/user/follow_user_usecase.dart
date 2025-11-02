import '../../repositories/user_repository.dart';

class FollowUserUseCase {
  final UserRepository repository;

  FollowUserUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.followUser(userId);
  }
}
