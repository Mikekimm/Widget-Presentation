import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  final UserEntity user;
  final Map<String, bool> followedPosts;
  final Map<String, bool> likedPosts;
  final Map<String, bool> bookmarkedPosts;

  const AccountLoaded(
    this.user, {
    this.followedPosts = const {},
    this.likedPosts = const {},
    this.bookmarkedPosts = const {},
  });

  AccountLoaded copyWith({
    UserEntity? user,
    Map<String, bool>? followedPosts,
    Map<String, bool>? likedPosts,
    Map<String, bool>? bookmarkedPosts,
  }) {
    return AccountLoaded(
      user ?? this.user,
      followedPosts: followedPosts ?? this.followedPosts,
      likedPosts: likedPosts ?? this.likedPosts,
      bookmarkedPosts: bookmarkedPosts ?? this.bookmarkedPosts,
    );
  }

  @override
  List<Object?> get props => [user, followedPosts, likedPosts, bookmarkedPosts];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountUpdating extends AccountState {
  final UserEntity user;

  const AccountUpdating(this.user);

  @override
  List<Object?> get props => [user];
}

class AccountUpdated extends AccountState {
  final UserEntity user;

  const AccountUpdated(this.user);

  @override
  List<Object?> get props => [user];
}
