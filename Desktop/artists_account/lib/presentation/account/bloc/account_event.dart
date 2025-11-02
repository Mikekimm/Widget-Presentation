import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends AccountEvent {
  final String userId;

  const LoadUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshUserEvent extends AccountEvent {
  final String userId;

  const RefreshUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUserEvent extends AccountEvent {
  final String name;
  final String bio;

  const UpdateUserEvent({
    required this.name,
    required this.bio,
  });

  @override
  List<Object?> get props => [name, bio];
}

class FollowUserEvent extends AccountEvent {
  final String userId;

  const FollowUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleFollowPostEvent extends AccountEvent {
  final String followKey;

  const ToggleFollowPostEvent(this.followKey);

  @override
  List<Object?> get props => [followKey];
}

class ToggleLikePostEvent extends AccountEvent {
  final String postId;

  const ToggleLikePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ToggleBookmarkPostEvent extends AccountEvent {
  final String postId;

  const ToggleBookmarkPostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
