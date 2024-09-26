import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/auth_entities/user_entity.dart';
import '../../../../domain/usecases/auth/auth_usecases.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthUsecases _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password,bool rememberMe) async {
    emit(LoginLoading());

    final result = await _loginUseCase.login(email: email, password: password,rememberMe: rememberMe);

    result.fold(
          (error) => emit(LoginError(message: error.message)),
          (user) => emit(LoginSuccess(user: user)),
    );
  }
}
