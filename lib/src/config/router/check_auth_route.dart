import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/src/presentation/cubit/auth/user_manager/auth_cubit.dart';

import '../../core/database/hive.dart';
import 'app_router.gr.dart';
@RoutePage()
class CheckAuthRoute extends StatelessWidget {
  const CheckAuthRoute({super.key});

  @override
  Widget build(BuildContext context) {
    // Read HiveService instance
    final hiveService = GetIt.instance<HiveService>();
    // Get the "Remember Me" value from Hive
    final rememberMe = hiveService.getRememberMe();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (rememberMe) {
            // Navigate to MasterRoute if authenticated and "Remember Me" is true
            context.router.replace(MasterRoute());
          } else {
            // Navigate to SigninRoute if authenticated but "Remember Me" is false
            context.router.replace(SigninRoute());
          }
        } else {
          // Navigate to SigninRoute if not authenticated
          context.router.replace(SigninRoute());
        }
      },
      child: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
