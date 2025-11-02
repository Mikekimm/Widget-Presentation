import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';
import '../../../domain/usecases/user/update_user_usecase.dart';
import '../../../domain/usecases/user/follow_user_usecase.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final FollowUserUseCase followUserUseCase;

  AccountBloc({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.followUserUseCase,
  }) : super(const AccountInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<RefreshUserEvent>(_onRefreshUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<FollowUserEvent>(_onFollowUser);
    on<ToggleFollowPostEvent>(_onToggleFollowPost);
    on<ToggleLikePostEvent>(_onToggleLikePost);
    on<ToggleBookmarkPostEvent>(_onToggleBookmarkPost);
  }

  Future<void> _onLoadUser(
    LoadUserEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final user = await getUserUseCase(event.userId);
      emit(AccountLoaded(user));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onRefreshUser(
    RefreshUserEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final user = await getUserUseCase(event.userId);
      emit(AccountLoaded(user));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<AccountState> emit,
  ) async {
    if (state is AccountLoaded) {
      final currentUser = (state as AccountLoaded).user;
      emit(AccountUpdating(currentUser));

      try {
        final updatedUser = UserEntity(
          id: currentUser.id,
          name: event.name,
          username: currentUser.username,
          bio: event.bio,
          profession: currentUser.profession,
          location: currentUser.location,
          profileImageUrl: currentUser.profileImageUrl,
        );

        await updateUserUseCase(updatedUser);
        emit(AccountUpdated(updatedUser));
        emit(AccountLoaded(updatedUser));
      } catch (e) {
        emit(AccountError(e.toString()));
        emit(AccountLoaded(currentUser));
      }
    }
  }

  Future<void> _onFollowUser(
    FollowUserEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await followUserUseCase(event.userId);
      add(RefreshUserEvent(event.userId));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  void _onToggleFollowPost(
    ToggleFollowPostEvent event,
    Emitter<AccountState> emit,
  ) {
    if (state is AccountLoaded) {
      final currentState = state as AccountLoaded;
      final updatedFollowed = Map<String, bool>.from(currentState.followedPosts);
      updatedFollowed[event.followKey] = !(updatedFollowed[event.followKey] ?? false);
      
      emit(currentState.copyWith(followedPosts: updatedFollowed));
    }
  }

  void _onToggleLikePost(
    ToggleLikePostEvent event,
    Emitter<AccountState> emit,
  ) {
    if (state is AccountLoaded) {
      final currentState = state as AccountLoaded;
      final updatedLiked = Map<String, bool>.from(currentState.likedPosts);
      updatedLiked[event.postId] = !(updatedLiked[event.postId] ?? false);
      
      emit(currentState.copyWith(likedPosts: updatedLiked));
    }
  }

  void _onToggleBookmarkPost(
    ToggleBookmarkPostEvent event,
    Emitter<AccountState> emit,
  ) {
    if (state is AccountLoaded) {
      final currentState = state as AccountLoaded;
      final updatedBookmarked = Map<String, bool>.from(currentState.bookmarkedPosts);
      updatedBookmarked[event.postId] = !(updatedBookmarked[event.postId] ?? false);
      
      emit(currentState.copyWith(bookmarkedPosts: updatedBookmarked));
    }
  }
}
