part of '../main.dart';

final injector = GetIt.instance;

Future<void> init() async {
  final authBox = await Hive.openBox('authBox');
  injector
    // Hive Service
    ..registerLazySingleton<HiveService>(() => HiveService(authBox))
    //* Network
    ..registerLazySingleton<DioClient>(() => DioClient(injector<HiveService>()))
// Register SocketService
    ..registerLazySingleton<SocketService>(SocketService.new)
    //* Database
    ..registerLazySingleton<LocalDatabase>(LocalDatabase.new)
    //* Cubits
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    ..registerLazySingleton<LoginCubit>(() => LoginCubit(
          injector(),
        ))
    ..registerLazySingleton<AuthCubit>(
        () => AuthCubit(injector(), injector<HiveService>()))
    // Register GetMessageCubit with required parameters
    ..registerFactoryParam<GetMessageCubit,
        Tuple3<String, HiveService, SocketService>, void>(
      (params, _) => GetMessageCubit(
        injector<MessageUsecases>(),
        params.item1,
        params.item2,
        params.item3,
      ),
    )
    ..registerFactoryParam<ConversationsBloc, String, void>(
        (userId, _) => ConversationsBloc(
              injector<MessageUsecases>(),
              userId,
              injector<HiveService>(),
              injector<SocketService>(),
              // Pass userId to the bloc constructor
            ))
    ..registerFactory<ChatInputBloc>(
        () => ChatInputBloc(injector<GetMessageCubit>()))
    ..registerLazySingleton<SignupCubit>(() => SignupCubit(injector()))
    ..registerLazySingleton<ImagePickerCubit>(() => ImagePickerCubit())
    ..registerLazySingleton<GetPopularMoviesCubit>(
        () => GetPopularMoviesCubit(injector()))
    ..registerLazySingleton<GetSavedMoviesCubit>(
        () => GetSavedMoviesCubit(injector()))
    ..registerFactory<ToggleBookmarkCubit>(
        () => ToggleBookmarkCubit(injector()))
    //* Data Sources
    ..registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl(injector()))
    ..registerLazySingleton<AuthRemoteDataSource>(() =>
        AuthRemoteDataSourceImpl(
            injector<DioClient>(), injector<HiveService>()))
    ..registerLazySingleton<MovieLocalDataSource>(
        () => MovieLocalDataSourceImpl(injector<LocalDatabase>()))
    ..registerLazySingleton<MessageRemoteDataSource>(
        () => MessageRemoteDataSourceImpl(injector(), injector<HiveService>()))

    //* Repositories
    ..registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(injector(), injector()))
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl((injector())))
    ..registerLazySingleton<MessageRepository>(
        () => MessageRepositoryImpl((injector())))
    //* Usecases
    ..registerLazySingleton<MovieUsecases>(() => MovieUsecases(injector()))
    ..registerLazySingleton<AuthUsecases>(() => AuthUsecases(injector()))
    ..registerLazySingleton<MessageUsecases>(() => MessageUsecases(injector()));
}
