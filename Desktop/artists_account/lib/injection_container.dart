import 'package:get_it/get_it.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/user/follow_user_usecase.dart';
import 'domain/usecases/user/get_user_usecase.dart';
import 'domain/usecases/user/update_user_usecase.dart';
import 'presentation/account/bloc/account_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => AccountBloc(
      getUserUseCase: sl(),
      updateUserUseCase: sl(),
      followUserUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => FollowUserUseCase(sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
}
