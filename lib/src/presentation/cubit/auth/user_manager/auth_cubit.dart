// auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/hive.dart';
import '../../../../domain/entities/auth_entities/user_entity.dart';
import '../../../../domain/usecases/auth/auth_usecases.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUsecases _authUsecases;
  final HiveService _hiveService; // Injecting HiveService for token management

  AuthCubit(this._authUsecases, this._hiveService) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> loggedIn(String email, String password,bool rememberMe) async {
    emit(AuthLoading());

    final result = await _authUsecases.login(email: email, password: password,rememberMe: rememberMe);

    result.fold(
          (error) => emit(AuthError(error.message)),
          (user) async {

        //await _hiveService.saveAuthToken(user.token);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> logout() async {

    await _hiveService.clearAuthToken();
    emit(AuthUnauthenticated());
  }

  Future<void> checkAuthStatus() async {

    final token = await _hiveService.getAuthToken();
    if (token != null) {
      final result = await _authUsecases.getUserFromToken();
      result.fold(
            (error) => emit(AuthUnauthenticated()),
            (user) => emit(AuthAuthenticated(user)),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
