import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users.dart';
import '../bloc/user_bloc.dart';
import '../providers/user_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - User
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUsers: sl(),
      getUserById: sl(),
      getPostsByUserId: sl(),
    ),
  );

  // Provider
  sl.registerFactory(
    () => UserProvider(
      getUsers: sl(),
      getUserById: sl(),
      getPostsByUserId: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => GetPostsByUserId(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => Dio());
}

Future<void> reset() async {
  await sl.reset();
  await init();
}
