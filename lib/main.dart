import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie_app/src/core/database/local_database.dart';
import 'package:movie_app/src/core/network/dio_client.dart';
import 'package:movie_app/src/core/network/firebase_api.dart';
import 'package:movie_app/src/core/network/socketservice.dart';
import 'package:movie_app/src/core/theme/app_theme.dart';
import 'package:movie_app/src/core/theme/cubit/theme_cubit.dart';
import 'package:movie_app/src/data/datasources/export_datasources.dart';
import 'package:movie_app/src/data/datasources/local/movie/movie_local_data_source.dart';
import 'package:movie_app/src/data/datasources/local/movie/movie_local_data_source_impl.dart';
import 'package:movie_app/src/data/repositories/export_repository_impls.dart';
import 'package:movie_app/src/domain/repositories/export_repositories.dart';
import 'package:movie_app/src/domain/usecases/export_usecases.dart';
import 'package:movie_app/src/presentation/cubit/auth/export_auth_cubits.dart';
import 'package:movie_app/src/presentation/cubit/auth/user_manager/auth_cubit.dart';
import 'package:movie_app/src/presentation/cubit/image_picker/export_image_picker_cubits.dart';
import 'package:movie_app/src/presentation/cubit/message/conversations/conversations_bloc.dart';
import 'package:movie_app/src/presentation/cubit/message/get_message/get_message_cubit.dart';
import 'package:movie_app/src/presentation/cubit/movie/export_movie_cubits.dart';
import 'package:movie_app/src/presentation/cubit/movie/get_saved_movies/get_saved_movies_cubit.dart';
import 'package:movie_app/src/presentation/cubit/movie/toggle_bookmark/toggle_bookmark_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

import 'firebase_options.dart';
import 'src/config/router/app_router.dart';
import 'src/core/database/hive.dart';

part './src/injector.dart';

final router = AppRouter();
late final HiveService hiveService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Hive.initFlutter();
  await Hive.openBox('authBox');

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;

  await init();
  await injector<LocalDatabase>().initialize();

  hiveService = injector<HiveService>();

  final userId = await hiveService.getUserId();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final dioClient = injector<DioClient>();
  await FirebaseApi(
    dioClient: dioClient, // Pass the DioClient instance here
    hiveService: hiveService,
  ).initNotifications();
  runApp(MyApp(userId: userId ?? ''));
}

class MyApp extends StatelessWidget {
  final String userId;

  const MyApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider<ScreenHeight>(
          create: (_) => ScreenHeight(),
        ),

        BlocProvider<ThemeCubit>(create: (context) => injector<ThemeCubit>()),
        BlocProvider<LoginCubit>(create: (context) => injector<LoginCubit>()),
        BlocProvider<AuthCubit>(create: (context) => injector<AuthCubit>()),
        BlocProvider<GetMessageCubit>(
          create: (context) => injector<GetMessageCubit>(
            param1: Tuple3(
                userId, injector<HiveService>(), injector<SocketService>()),
          ),
        ),
        BlocProvider<ConversationsBloc>(
          create: (context) => injector<ConversationsBloc>(param1: userId),
        ),
        BlocProvider<SignupCubit>(create: (context) => injector<SignupCubit>()),
        BlocProvider<ImagePickerCubit>(
            create: (context) => injector<ImagePickerCubit>()),
        // BlocProvider<GetMovieCreditsCubit>(create: (context) => injector<GetMovieCreditsCubit>()),
        BlocProvider<GetSavedMoviesCubit>(
            create: (context) =>
                injector<GetSavedMoviesCubit>()..getSavedMovieDetails()),
      ],
      child: ScreenUtilInit(
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                themeMode: themeState.themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerDelegate: AutoRouterDelegate(router),
                routeInformationParser: router.defaultRouteParser(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
